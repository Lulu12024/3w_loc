from django.shortcuts import render
from rest_framework.views import APIView 
from rest_framework import viewsets, permissions, status
from rest_framework.decorators import action
from .models import *
from rest_framework.response import Response
from django.db.models import Q
from .serializers import * 
from rest_framework.permissions import IsAuthenticated

# Create your views here.
class MessageViewSet(viewsets.ModelViewSet):
    queryset = Message.objects.all()
    serializer_class = MessageSerializer
    permission_classes = [IsAuthenticated]

    def list(self, request):
        """
        Liste des conversations
        """
        messages = Message.objects.filter(
            Q(sender=request.user) | Q(recipient=request.user)
        ).distinct('sender', 'recipient')
        
        serializer = self.get_serializer(messages, many=True)
        return Response(serializer.data)

    def create(self, request):
        """
        Envoyer un nouveau message
        """
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        
        # Définir l'expéditeur comme l'utilisateur connecté
        serializer.validated_data['sender'] = request.user
        
        message = serializer.save()
        return Response(
            self.get_serializer(message).data, 
            status=status.HTTP_201_CREATED
        )

    @action(detail=True, methods=['GET'])
    def conversation(self, request, pk=None):
        """
        Détails d'une conversation avec un utilisateur spécifique
        """
        destinataire_id = pk
        messages = Message.objects.filter(
            (Q(sender=request.user, recipient_id=destinataire_id) | 
             Q(recipient=request.user, sender_id=destinataire_id))
        ).order_by('date_envoi')
        
        serializer = MessageSerializer(messages, many=True)
        return Response(serializer.data)


    @action(detail=False, methods=['GET'])
    def recherche(self, request):
        """
        
        Recherche dans les messages
        """
        mot_cle = request.query_params.get('mot_cle')
        date = request.query_params.get('date')
        
        messages = Message.objects.filter(
            Q(sender=request.user) | Q(recipient=request.user)
        )
        
        if mot_cle:
            messages = messages.filter(
                Q(contenu__icontains=mot_cle)
            )
        
        if date:
            messages = messages.filter(date_envoi__date=date)
        
        serializer = MessageSerializer(messages, many=True)
        return Response(serializer.data)

    @action(detail=True, methods=['PUT'])
    def mark_as_read(self, request, pk=None):
        """
        PUT /messages/{messageId}/lu/
        Marquer un message comme lu
        """
        try:
            message = Message.objects.get(pk=pk, recipient=request.user)
            message.is_read = True
            message.save()
            
            return Response({
                "message": "Message marqué comme lu",
                "details": MessageSerializer(message).data
            })
        except Message.DoesNotExist:
            return Response(
                {"detail": "Message non trouvé"}, 
                status=status.HTTP_404_NOT_FOUND
            )
