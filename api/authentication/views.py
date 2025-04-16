from django.shortcuts import render
from django.contrib.auth import login, authenticate, logout , get_user_model
from rest_framework_simplejwt.tokens import AccessToken , RefreshToken 
from rest_framework_simplejwt.authentication import JWTAuthentication
from rest_framework.permissions import IsAuthenticated
from rest_framework_simplejwt.views import TokenObtainPairView , TokenRefreshView
from rest_framework.decorators import api_view
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from .models import *
import random
from django.utils import timezone
from django.contrib.auth.hashers import make_password
from django.conf import settings
from django.core.mail import EmailMessage
from django.template.loader import render_to_string
from rest_framework.generics import RetrieveAPIView, UpdateAPIView
from django.shortcuts import get_object_or_404
from rest_framework.generics import ListAPIView
from .serializers import *
from rest_framework import generics
from django.utils.translation import gettext_lazy as _

# Create your views here.
class UserLoginAPIView(APIView):
    authentication_classes = []

    def post(self, request, *args, **kwargs):
        email = request.data.get('email')
        password = request.data.get('password')
        
        if email and password:
            user = authenticate(email=email, password=password)
            if user:
                serializer = UserSerializer(user)
                # token, created = Token.objects.get_or_create(user=user)

                # Génération du token JWT
                token = AccessToken.for_user(user)

                refresh_token = RefreshToken.for_user(user)
                
                print(token)
                return Response({"status ": "Success" ,"message ": "SUCCESS" ,"user" : serializer.data, "accesstoken" : {"token": str(token),"refresh_token" : str(refresh_token)} }, status=status.HTTP_200_OK)
            else:
                return Response({"status ": "Error" ,"message": "Bad credentials. Please try again"}, status=status.HTTP_400_BAD_REQUEST)
        
        return Response({"status ": "Error" ,"message": "Some fields are not filled in" }, status=status.HTTP_400_BAD_REQUEST)


# VUE DE CONNEXION
class AdminLoginAPIView(APIView):
    authentication_classes = []

    def post(self, request, *args, **kwargs):
        username = request.data.get('username')
        password = request.data.get('password')
        
        if username and password:
            user = authenticate(username=username, password=password)
            if user and user.role.role == "ADMINISTRATEUR":
                serializer = UserSerializer(user)
                # token, created = Token.objects.get_or_create(user=user)

                # Génération du token JWT
                token = AccessToken.for_user(user)

                refresh_token = RefreshToken.for_user(user)
                
                print(token)
                return Response({"status ": "Success" ,"message ": "SUCCESS" ,"user" : serializer.data, "accesstoken" : {"token": str(token),"refresh_token" : str(refresh_token)} }, status=status.HTTP_200_OK)
            else:
                return Response({"status ": "Error" ,"message": "Bad credentials. Please try again"}, status=status.HTTP_400_BAD_REQUEST)
        
        return Response({"status ": "Error" ,"message": "Some fields are not filled in" }, status=status.HTTP_400_BAD_REQUEST)

# VUE D'INSCRIPTION
class UserSignupAPIView(APIView):
    def post(self, request, *args, **kwargs):
        country_id= None

        email = request.data.get('email')
        password = request.data.get('password')
        confirm_password = request.data.get('confirm_password')
        country_id = request.data.get('country_id')  # Récupérer l'ID du domaine
        # first_name = request.data.get('first_name')
        # last_name = request.data.get('last_name')

        #  ON verifie les mots de passe
        # if password and confirm_password:
        #     if password != confirm_password:
        #         return Response({"status ": "Error" , "message" : "Les deux mots de passe ne coincident pas"}, status=status.HTTP_400_BAD_REQUEST)
        # else:
        #     return Response({"status ": "Error" , "message" : "Veuillez confirmer le mot de passe"}, status=status.HTTP_400_BAD_REQUEST)
         
        role = Role.objects.get(libelle = "USER")
        # group = Group.objects.get(name = "USER")
        serializer = UserSerializer(data=request.data)
        if serializer.is_valid():
            # user = serializer.save()
            user = User.objects.create(
                username = email,
                email = email,
                password = make_password(password),
                role = role,
                country_id=country_id, 
                user_code = generate_unique_user_code(),
                # first_name = first_name,
                # last_name = last_name
            )
            # user.role = role
            # if parent:
            #     user.parents.set([parent])  
            # user.parent = parent
            # user.groups.add(group)
            user.save()

            serializer = UserSerializer(user)
            return Response({"status ": "Success" ,"message ": "User successfully created" ,"data" : {"user": serializer.data}}, status=status.HTTP_201_CREATED)
        return Response({"status ": "Error" , "message" : serializer.errors}, status=status.HTTP_400_BAD_REQUEST)
  
class PasswordResetRequestAPIView(APIView):
    def post(self, request, *args, **kwargs):
        email = request.data.get('email')
        if email:
            try:
                user = User.objects.get(email=email)
            except User.DoesNotExist:
                return Response({"status": "Error", "message": "No users with this email address were found"}, status=status.HTTP_404_NOT_FOUND)

            # Générer un nouveau mot de passe puis l'assigner a l'utilisateur
            code  = generate_unique_user_code(),
            # new_password = ''.join(random.choices(string.ascii_uppercase + string.digits, k=8))
            # print(new_password)
            # user.password = make_password(new_password)
            # user.save()

            # Envoyer le code par e-mail
            subject = _('Reset password')
            message = _("Nous avons reçu une demande de changement de mot de passe sur votre compte 3w-Loc.Vous pouvez réinitialiser votre mot de passe en utilsant le code: %s.") % code
            # send_mail(subject, message, settings.EMAIL_HOST_USER, [email])
            context = { }
            # html_content = render_to_string('password_reset_mail.html', context)

            # Créer l'objet EmailMessage
            email = EmailMessage(
                subject=subject ,  # Le sujet de l'e-mail
                body=message,  # Le contenu HTML de l'e-mail
                from_email=settings.EMAIL_HOST_USER,  # L'adresse e-mail de l'expéditeur (doit être la même que l'adresse d'authentification SMTP)
                to=[email],  # La liste des destinataires (peut être une liste de plusieurs adresses e-mail)
            )
            
            # Définir le type de contenu de l'e-mail (HTML)
            email.content_subtype = 'html'

            # Envoyer l'e-mail
            email.send()
            
            # on Stock le code et l'heure d'expirat°
            # user.password_reset_token = code
            # user.password_reset_token_expiration = timezone.now() + timedelta(minutes=5)  # Expiration après 5 minutes
            # user.save()

            # request.session['reset_password_code'] = code

            return Response({"status": "Success", "message": "Operation successfully completed"}, status=status.HTTP_200_OK)
        else:
            return Response({"status": "Error", "message": "Please provide an email address"}, status=status.HTTP_400_BAD_REQUEST)


class PasswordResetConfirmAPIView(APIView):
    def post(self, request, *args, **kwargs):
        user_id = request.data.get('user_id')
        code = request.data.get('code')
        new_password = request.data.get('new_password')
        new_password2 = request.data.get('new_password2')

        try:
            user = User.objects.get(pk = str(user_id) )
        except User.DoesNotExist as e:
            print(e)
            return Response({"status": "Error", "message": "No users with this email address were found"}, status=status.HTTP_400_BAD_REQUEST)
        

        # Vérifier si le code est valide et non expiré
        if code and user.password_reset_token == code:
            if user.password_reset_token_expiration and user.password_reset_token_expiration > timezone.now():
                if new_password == new_password2:
                    # Réinitialiser le mot de passe pour l'utilisateur
                    user.set_password(new_password)
                    user.save()
                    return Response({"status": "Success", "message": "Password successfully reset"}, status=status.HTTP_200_OK)
                else:
                    return Response({"status": "Error", "message": "The two passwords do not match"}, status=status.HTTP_400_BAD_REQUEST)
            else:
                return Response({"status": "Error", "message": "Password reset code has expired"}, status=status.HTTP_400_BAD_REQUEST)
        else:
            return Response({"status": "Error", "message": "Password reset code is invalid"}, status=status.HTTP_400_BAD_REQUEST)

class RetrieveUserByUidView(RetrieveAPIView):
    queryset = User.objects.all()
    serializer_class = UserSerializer
    # permission_classes = [IsAuthenticated]

    def get_object(self):
        id = self.kwargs.get('id')  # Récupérer le `uid` depuis l'URL
        return get_object_or_404(User, id=id)
    

class UsersListView(ListAPIView):
    queryset = User.objects.all()
    serializer_class = UserSerializer
    # Uncomment this line to require authentication
    # permission_classes = [IsAuthenticated]

class UpdateUserView(UpdateAPIView):
    queryset = User.objects.all()
    serializer_class = UserEditSerializer
    # permission_classes = [IsAuthenticated]

    def get_object(self):
        id = self.kwargs.get('id')  # Récupérer le `uid` depuis l'URL
        return get_object_or_404(User, id=id)

    def update(self, request, *args, **kwargs):
        # Appel de la méthode de mise à jour standard
        partial = kwargs.pop('partial', False)
        instance = self.get_object()
        serializer = self.get_serializer(instance, data=request.data, partial=partial)
        serializer.is_valid(raise_exception=True)
        self.perform_update(serializer)

        # Recharger l'instance mise à jour
        updated_instance = self.get_object()
        user_serializer = UserSerializer(updated_instance)

        # Retourner les données du serializer utilisateur
        return Response({
            "status": "Success",
            "message": "User successfully updated",
            "data": user_serializer.data
        }, status=status.HTTP_200_OK)

    
def logout_user(request):
    try:
        logout(request)

        return Response({"status": "Success", "message": "Operation successfully completed"} ,status=status.HTTP_200_OK)
    
    except User.DoesNotExist:
        return Response({"status": "Error", "message": "No users found"}, status=status.HTTP_404_NOT_FOUND)
    except Exception as e:
        return Response({"status": "Error", "message": str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
    


class TokenRefreshAPIView(APIView):
    # permission_classes = [IsAuthenticated]
    authentication_classes = [JWTAuthentication]

    def post(self, request, *args, **kwargs):
        # Obtenez le token JWT à partir de l'en-tête d'authentification
        user = request.user
        User = get_user_model()
        
        # Sérialisez l'utilisateur
        serializer = UserSerializer(user)
        print(user)
        # Rafraîchir le token JWT
        try:
            # refresh_token = RefreshToken(token)
            token = AccessToken.for_user(user)
            print(token)
            return Response({
                "status": "Success",
                "message": "Token successfully refreshed",
                "data": {
                    "token": str(token)
                }
            }, status=status.HTTP_200_OK)
        except Exception as e:
            return Response({
                "status": "Error",
                "message": f"Unable to refresh token: {str(e)}"
            }, status=status.HTTP_400_BAD_REQUEST)
       

class GetUserFromTokenView(APIView):
    authentication_classes = [JWTAuthentication]

    def get(self, request):
        # Obtenez l'utilisateur à partir du token JWT
        user = request.user
        User = get_user_model()
        
        # Sérialisez l'utilisateur
        serializer = UserSerializer(user)

        return Response(serializer.data, status=status.HTTP_200_OK)


#########################################################

class PaysListView(generics.ListCreateAPIView):
    queryset = Pays.objects.all()
    serializer_class = PaysSerializer

class PaysDetailByIdView(generics.RetrieveAPIView):
    queryset = Pays.objects.all()
    serializer_class = PaysSerializer

class PaysUpdateView(generics.UpdateAPIView):
    queryset = Pays.objects.all()
    serializer_class = PaysSerializer

class PaysDeleteView(generics.DestroyAPIView):
    queryset = Pays.objects.all()
    serializer_class = PaysSerializer


######################################################################################"
# #################### CRUD ROLE ################################################"

class RoleListView(generics.ListCreateAPIView):
    queryset = Role.objects.all()
    serializer_class = RoleSerializer

class RoleDetailByIdView(generics.RetrieveAPIView):
    queryset = Role.objects.all()
    serializer_class = RoleSerializer

class RoleUpdateView(generics.UpdateAPIView):
    queryset = Role.objects.all()
    serializer_class = RoleSerializer

class RoleDeleteView(generics.DestroyAPIView):
    queryset = Role.objects.all()
    serializer_class = RoleSerializer

############################################################################################