from datetime import timedelta
from django.shortcuts import render
from operation.models import *
from operation.serializers import *
from rest_framework import generics, status
from rest_framework.parsers import MultiPartParser, FormParser
from rest_framework.response import Response
from rest_framework.views import APIView 
from rest_framework import viewsets, permissions, status
from rest_framework.decorators import action
from django.utils import timezone 
from rest_framework.permissions import IsAuthenticated


#CATEGORY#
#########################################################

class CategoryListView(generics.ListCreateAPIView):
    queryset = Category.objects.all()
    serializer_class = CategorySerializer

class CategoryDetailByIdView(generics.RetrieveAPIView):
    queryset = Category.objects.all()
    serializer_class = CategorySerializer

class CategoryUpdateView(generics.UpdateAPIView):
    queryset = Category.objects.all()
    serializer_class = CategorySerializer

class CategoryDeleteView(generics.DestroyAPIView):
    queryset = Category.objects.all()
    serializer_class = CategorySerializer

#ANNOUNCEMENT STATUS#
#########################################################

class AnnoucementStatusListView(generics.ListCreateAPIView):
    queryset = AnnoucementStatus.objects.all()
    serializer_class = AnnoucementStatusSerializer

class AnnoucementStatusDetailByIdView(generics.RetrieveAPIView):
    queryset = AnnoucementStatus.objects.all()
    serializer_class = AnnoucementStatusSerializer

class AnnoucementStatusUpdateView(generics.UpdateAPIView):
    queryset = AnnoucementStatus.objects.all()
    serializer_class = AnnoucementStatusSerializer

class AnnoucementStatusDeleteView(generics.DestroyAPIView):
    queryset = AnnoucementStatus.objects.all()
    serializer_class = AnnoucementStatusSerializer

######################################################################################"
# #################### CRUD TYPE DOCUMENT ################################################"

class TypeDocumentListView(generics.ListCreateAPIView):
    queryset = TypeDocument.objects.all()
    serializer_class = TypeDocumentSerializer

class TypeDocumentDetailByIdView(generics.RetrieveAPIView):
    queryset = TypeDocument.objects.all()
    serializer_class = TypeDocumentSerializer

class TypeDocumentUpdateView(generics.UpdateAPIView):
    queryset = TypeDocument.objects.all()
    serializer_class = TypeDocumentSerializer

class TypeDocumentDeleteView(generics.DestroyAPIView):
    queryset = TypeDocument.objects.all()
    serializer_class = TypeDocumentSerializer

############################################################################################

######################################################################################"
# #################### CRUD TYPE STAT ################################################"

class TypeStatListView(generics.ListCreateAPIView):
    queryset = TypeStat.objects.all()
    serializer_class = TypeStatSerializer

class TypeStatDetailByIdView(generics.RetrieveAPIView):
    queryset = TypeStat.objects.all()
    serializer_class = TypeDocumentSerializer

class TypeStatUpdateView(generics.UpdateAPIView):
    queryset = TypeDocument.objects.all()
    serializer_class = TypeStatSerializer

class TypeStatDeleteView(generics.DestroyAPIView):
    queryset = TypeStat.objects.all()
    serializer_class = TypeStatSerializer

############################################################################################

######################################################################################"
# #################### CRUD SUB CATEGORY ################################################"

class SubCategoryListView(generics.ListCreateAPIView):
    queryset = SubCategory.objects.all()
    serializer_class = SubCategorySerializer

class SubCategoryDetailByIdView(generics.RetrieveAPIView):
    queryset = SubCategory.objects.all()
    serializer_class = SubCategorySerializer
    # lookup_field = 'uid'

class SubCategoryUpdateView(generics.UpdateAPIView):
    queryset = SubCategory.objects.all()
    serializer_class = SubCategorySerializer
    # lookup_field = 'uid'

class SubCategoryDeleteView(generics.DestroyAPIView):
    queryset = SubCategory.objects.all()
    serializer_class = SubCategorySerializer
    # lookup_field = 'uid'

############################################################################################



######################################################################################"
# #################### CRUD BOOKING STATUT ################################################"

class BookingStatusListView(generics.ListCreateAPIView):
    queryset = BookingStatus.objects.all()
    serializer_class = BookingStatusSerializer

class BookingStatusDetailByIdView(generics.RetrieveAPIView):
    queryset = BookingStatus.objects.all()
    serializer_class = BookingStatusSerializer

class BookingStatusUpdateView(generics.UpdateAPIView):
    queryset = BookingStatus.objects.all()
    serializer_class = BookingStatusSerializer

class BookingStatusDeleteView(generics.DestroyAPIView):
    queryset = BookingStatus.objects.all()
    serializer_class = BookingStatusSerializer

############################################################################################



######################################################################################"
# #################### CRUD TYPE DE VISIBILITE ################################################"

class TypeVisibilityListView(generics.ListCreateAPIView):
    queryset = TypeVisibility.objects.all()
    serializer_class = TypeVisibilitySerializer

class TypeVisibilityDetailByIdView(generics.RetrieveAPIView):
    queryset = TypeVisibility.objects.all()
    serializer_class = TypeVisibilitySerializer

class TypeVisibilityUpdateView(generics.UpdateAPIView):
    queryset = TypeVisibility.objects.all()
    serializer_class = TypeVisibilitySerializer

class TypeVisibilityDeleteView(generics.DestroyAPIView):
    queryset = TypeVisibility.objects.all()
    serializer_class = TypeVisibilitySerializer

############################################################################################


######################################################################################"
# #################### CRUD TYPE DE VISIBILITE ################################################"

class TypeListView(generics.ListCreateAPIView):
    queryset = Type.objects.all()
    serializer_class = TypeSerializer

class TypeDetailByIdView(generics.RetrieveAPIView):
    queryset = Type.objects.all()
    serializer_class = TypeSerializer

class TypeUpdateView(generics.UpdateAPIView):
    queryset = Type.objects.all()
    serializer_class = TypeSerializer

class TypeDeleteView(generics.DestroyAPIView):
    queryset = Type.objects.all()
    serializer_class = TypeSerializer

############################################################################################


######################################################################################"
# #################### CRUD ANNOUCEMENT ################################################"
class AnnouncementListCreateView(generics.ListCreateAPIView):
    queryset = Announcement.objects.all()
    print(queryset)
    def get_serializer_class(self):
        if self.request.method == 'POST':
            return AnnouncementCreateSerializer
        return AnnouncementSerializer
    
    def perform_create(self, serializer):
        initial_status = AnnoucementStatus.objects.first()
        if not initial_status:
            raise ValueError("initial pas trouvé")
        
        # STATUT INITIAL
        announcement = serializer.save(status=initial_status)
        return announcement

class AnnouncementDetailView(generics.RetrieveAPIView):
    queryset = Announcement.objects.all()
    serializer_class = AnnouncementSerializer

class AnnouncementUpdateView(generics.UpdateAPIView):
    queryset = Announcement.objects.all()
    
    def get_serializer_class(self):
        if self.request.method == 'PATCH':
            return AnnouncementCreateSerializer
        return AnnouncementSerializer

class AnnouncementDeleteView(generics.DestroyAPIView):
    queryset = Announcement.objects.all()

class AnnouncementPictureUploadView(APIView):
    parser_classes = (MultiPartParser, FormParser)
    
    def post(self, request, announcement_id, format=None):
        try:
            
            announcement = Announcement.objects.get(id=announcement_id)
            
            
            images = request.FILES.getlist('images')
            uploaded_pictures = []
            
            for image in images:
                # Create picture instance
                picture_serializer = AnnouncementPictureSerializer(data={
                    'announcement': announcement.id,
                    'image': image
                })
                
                if picture_serializer.is_valid():
                    picture = picture_serializer.save()
                    uploaded_pictures.append(picture_serializer.data)
                else:
                    # If any image fails validation, return error
                    return Response(
                        picture_serializer.errors, 
                        status=status.HTTP_400_BAD_REQUEST
                    )
            
            return Response(
                {
                    'message': f'{len(uploaded_pictures)} image(s) uploaded successfully',
                    'pictures': uploaded_pictures
                }, 
                status=status.HTTP_201_CREATED
            )
        
        except Announcement.DoesNotExist:
            return Response(
                {'error': 'Announcement not found'}, 
                status=status.HTTP_404_NOT_FOUND
            )
        except Exception as e:
            return Response(
                {'error': str(e)}, 
                status=status.HTTP_500_INTERNAL_SERVER_ERROR
            )

class AnnouncementPictureDeleteView(generics.DestroyAPIView):
    queryset = AnnouncementPicture.objects.all()
    serializer_class = AnnouncementPictureSerializer


###########################################################################################################################################
########################################################### BOOKING #######################################################################

# Booking Views
class BookingListCreateView(generics.ListCreateAPIView):
    queryset = Booking.objects.all()
    serializer_class = BookingSerializer
    permission_classes = [permissions.IsAuthenticated]
    
    def perform_create(self, serializer):
        serializer.save(locataire=self.request.user)
        

class BookingDetailView(generics.RetrieveAPIView):
    queryset = Booking.objects.all()
    serializer_class = BookingSerializer
    permission_classes = [permissions.IsAuthenticated]
    

class BookingUpdateView(generics.UpdateAPIView):
    queryset = Booking.objects.all()
    serializer_class = BookingSerializer
    permission_classes = [permissions.IsAuthenticated]
    

class BookingDeleteView(generics.DestroyAPIView):
    queryset = Booking.objects.all()
    serializer_class = BookingSerializer
    permission_classes = [permissions.IsAuthenticated]
    
###########################################################################################################################################
################################################ KYC STATUT ###################################################################################
class KycStatusListView(generics.ListCreateAPIView):
    queryset = KycStatus.objects.all()
    serializer_class = KycStatusSerializer

class KycStatusDetailByIdView(generics.RetrieveAPIView):
    queryset = KycStatus.objects.all()
    serializer_class = KycStatusSerializer

class KycStatusUpdateView(generics.UpdateAPIView):
    queryset = KycStatus.objects.all()
    serializer_class = KycStatusSerializer

class KycStatusDeleteView(generics.DestroyAPIView):
    queryset = KycStatus.objects.all()
    serializer_class = KycStatusSerializer

###########################################################################################################################################
########################################################## GESTION SUBSCRIPTION ###########################################################

class SubscriptionViewSet(viewsets.ModelViewSet):
    queryset = Subscription.objects.all()
    serializer_class = SubscriptionSerializer
    permission_classes = [permissions.IsAuthenticated]

    def list(self, request):
        """
        Liste tous les plans d'abonnement disponibles
        """
        plans = Subscription.objects.filter(is_deleted=False)
        serializer = SubscriptionSerializer(plans, many=True)       
        return Response(serializer.data)

    def retrieve(self, request, pk=None):
        """
        Détails d'un plan d'abonnement spécifique
        """
        try:
            plan = Subscription.objects.get(pk=pk, is_deleted=False)
            serializer = SubscriptionSerializer(plan)
            return Response(serializer.data)
        except Subscription.DoesNotExist:
            return Response(
                {"detail": "Plan d'abonnement non trouvé"}, 
                status=status.HTTP_404_NOT_FOUND
            )

    @action(detail=False, methods=['POST'])
    def subscription(self, request):
        """
        Souscrire à un nouveau plan d'abonnement
        """
        plan_id = request.data.get('planId')
        methode_paiement = request.data.get('methodePaiement')

        try:
            plan = Subscription.objects.get(pk=plan_id, is_deleted=False)
            
            
            nouvel_abonnement = Subscription.objects.create(
                user=request.user,
                wording=plan.wording,
                nbre_annoucement=plan.nbre_annoucement,
                type_visibility=plan.type_visibility,
                duree_publication=plan.duree_publication
            )

            
            invoice = Invoice.objects.create(
                user=request.user,
                subscription=nouvel_abonnement,
                startDate=timezone.now(),
                endDate=timezone.now() + timedelta(days=30)  
            )

            return Response({
                "abonnement": SubscriptionSerializer(nouvel_abonnement).data,
                "facture": InvoiceSerializer(invoice).data,
                "message": "Abonnement souscrit avec succès"
            }, status=status.HTTP_201_CREATED)

        except Subscription.DoesNotExist:
            return Response(
                {"detail": "Plan d'abonnement invalide"}, 
                status=status.HTTP_400_BAD_REQUEST
            )
        
        
    @action(detail=False, methods=['GET'])
    def statistiques(self, request):
        """
        
        Récupérer les statistiques selon le niveau d'abonnement
        """
        user_subscription = request.user.subscription

       
        stats = {
            "nombre_vues": 0,
            "nombre_clics": 0,
            "reservations": 0,
            "messages_recus": 0
        }

        
        if user_subscription.wording == "Intermédiaire":
            stats.update({
                "taux_conversion": 0,
                "localisation_utilisateurs": [],
                "sources_trafic": []
            })

        
        if user_subscription.wording == "Premium":
            stats.update({
                "comparaison_annonces": [],
                "rapports_exportables": True
            })

        return Response(stats)

    @action(detail=False, methods=['GET'])
    def invoices(self, request):
        """
        GET /abonnements/factures/
        Historique des factures
        """
        factures = Invoice.objects.filter(user=request.user)
        serializer = InvoiceSerializer(factures, many=True)
        return Response(serializer.data)
    
###########################################################################################################################################

class DocumentUploadView(generics.CreateAPIView):
    permission_classes = [IsAuthenticated]
    serializer_class = DocumentSerializer
    
    def perform_create(self, serializer):
        serializer.save(user=self.request.user)

class UserVerificationView(APIView):
    permission_classes = [IsAuthenticated]
    
    def post(self, request):
        """
        Soumettre les documents pour vérification
        Cette action marque le compte comme "en attente de vérification"
        """
        user = request.user
        
        # Vérifier que l'utilisateur a téléchargé les documents nécessaires
        identity_documents = Document.objects.filter(
            user=user,
            type__wording__in=['Carte d\'identité', 'Passeport', 'Permis de conduire']
        )
        
        proof_of_address = Document.objects.filter(
            user=user,
            type__wording='Justificatif de domicile'
        )
        
        if not identity_documents:
            return Response(
                {'error': 'Veuillez télécharger une pièce d\'identité'}, 
                status=status.HTTP_400_BAD_REQUEST
            )
        
        if not proof_of_address:
            return Response(
                {'error': 'Veuillez télécharger un justificatif de domicile'}, 
                status=status.HTTP_400_BAD_REQUEST
            )
        
        # Mettre à jour le statut KYC de l'utilisateur
        # Il faut ajouter un champ kyc_status sur votre modèle User
        # user.kyc_status = 'PENDING'
        # user.save()
        
        # Créer une notification pour les administrateurs
        # ...
        
        return Response({'message': 'Documents soumis avec succès pour vérification'})

class AdminVerificationView(APIView):
    # Seuls les administrateurs peuvent accéder à cette vue
    permission_classes = [IsAuthenticated]
    
    def get(self, request):
        """
        Récupérer la liste des utilisateurs en attente de vérification
        """
        # Il faut ajouter un champ kyc_status sur votre modèle User
        # users_pending = User.objects.filter(kyc_status='PENDING')
        # serializer = UserSerializer(users_pending, many=True)
        # return Response(serializer.data)
        
        return Response([])  # À adapter selon votre modèle
    
    def post(self, request):
        """
        Valider ou rejeter la vérification d'un utilisateur
        """
        user_id = request.data.get('user_id')
        action = request.data.get('action')  # 'APPROVE' ou 'REJECT'
        
        if not user_id or not action:
            return Response(
                {'error': 'Paramètres manquants'}, 
                status=status.HTTP_400_BAD_REQUEST
            )
        
        try:
            user = User.objects.get(id=user_id)
        except User.DoesNotExist:
            return Response(
                {'error': 'Utilisateur non trouvé'}, 
                status=status.HTTP_404_NOT_FOUND
            )
        
        # Mettre à jour le statut KYC
        # if action == 'APPROVE':
        #     user.kyc_status = 'VERIFIED'
        # elif action == 'REJECT':
        #     user.kyc_status = 'REJECTED'
        # else:
        #     return Response(
        #         {'error': 'Action non valide'}, 
        #         status=status.HTTP_400_BAD_REQUEST
        #     )
        # 
        # user.save()
        
        # Créer une notification pour l'utilisateur
        # ...
        
        return Response({'message': f'Statut de vérification mis à jour: {action}'})