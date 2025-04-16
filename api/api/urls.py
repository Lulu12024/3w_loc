from django.contrib import admin
from django.urls import path, include
from rest_framework_simplejwt.views import TokenObtainPairView, TokenRefreshView
from rest_framework.routers import DefaultRouter
import authentication.views
import operation.views
import notification.views

# Configuration du routeur pour les viewsets
router = DefaultRouter()

# Router pour les abonnements
router.register(r'api/abonnements', operation.views.SubscriptionViewSet, basename='subscription')
# - GET  api/abonnements/                  Liste
# - GET  api/abonnements/{id}/             Détail
# - POST api/abonnements/subscription/     Souscrire
# - GET  api/abonnements/statistiques/     Statistique
# - GET  api/abonnements/invoices/         Facture

# Router pour les messages
router.register(r'api/messages', notification.views.MessageViewSet, basename='message')
# - GET api/messages/                                 Liste
# - POST api/messages/                                Create
# - GET /messages/{destinataireId}/conversation/      Détails d'une conversation avec un utilisateur spécifique
# - GET /messages/recherche/                          Recherche de message
# - PUT /messages/{messageId}/mark_as_read/           marquer comme lu

# Router pour les notifications
# router.register(r'api/notifications', notification.views.NotificationViewSet, basename='notification')
# - GET api/notifications/                            Liste des notifications de l'utilisateur
# - PUT api/notifications/{id}/mark_as_read/          Marquer une notification comme lue

urlpatterns = [
    # Administration Django
    path('admin/', admin.site.urls),
    
    # Inclusion des routes du routeur
    path('', include(router.urls)),
    
    ############################## AUTHENTICATION ######################################
    # Gestion des utilisateurs
    path('api/signup/', authentication.views.UserSignupAPIView.as_view(), name='user-signup'),
    path('api/login/', authentication.views.UserLoginAPIView.as_view(), name='user-login'),
    path('api/login-admin/', authentication.views.AdminLoginAPIView.as_view(), name='login-admin'),
    path('api/logout/', authentication.views.logout, name='user-logout'),
    path('api/password/reset/', authentication.views.PasswordResetRequestAPIView.as_view(), name='password_reset_request'),
    path('api/password/reset/confirm/', authentication.views.PasswordResetConfirmAPIView.as_view(), name='password_reset_confirm'),
    path('api/users/', authentication.views.UsersListView.as_view(), name='users-list'),
    path('api/users/<str:id>/', authentication.views.RetrieveUserByUidView.as_view(), name='retrieve-user'),
    path('api/users/update/<str:id>/', authentication.views.UpdateUserView.as_view(), name='update-user'),
    path('api/token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
    
    # Gestion des rôles
    path('api/role/', authentication.views.RoleListView.as_view(), name='Role-list'),
    path('api/role/id/<str:id>/', authentication.views.RoleDetailByIdView.as_view(), name='Role-detail-by-id'),
    path('api/role/update/<str:id>/', authentication.views.RoleUpdateView.as_view(), name='Role-update'),
    path('api/role/delete/<str:id>/', authentication.views.RoleDeleteView.as_view(), name='Role-delete'),
    
    # Gestion des pays
    path('api/country/', authentication.views.PaysListView.as_view(), name='Pays-list'),
    path('api/country/id/<str:id>/', authentication.views.PaysDetailByIdView.as_view(), name='Pays-detail-by-id'),
    path('api/country/update/<str:id>/', authentication.views.PaysUpdateView.as_view(), name='Pays-update'),
    path('api/country/delete/<str:id>/', authentication.views.PaysDeleteView.as_view(), name='Pays-delete'),
    
    ############################## OPERATIONS ######################################
    # Gestion des sous-catégories
    path('api/subcategory/', operation.views.SubCategoryListView.as_view(), name='subcategory-list'),
    path('api/subcategory/id/<str:id>/', operation.views.SubCategoryDetailByIdView.as_view(), name='subcategory-detail-by-id'),
    path('api/subcategory/update/<str:id>/', operation.views.SubCategoryUpdateView.as_view(), name='subcategory-update'),
    path('api/subcategory/delete/<str:id>/', operation.views.SubCategoryDeleteView.as_view(), name='subcategory-delete'),
    
    # Gestion des catégories
    path('api/category/', operation.views.CategoryListView.as_view(), name='category-list'),
    path('api/category/id/<str:id>/', operation.views.CategoryDetailByIdView.as_view(), name='category-detail-by-id'),
    path('api/category/update/<str:id>/', operation.views.CategoryUpdateView.as_view(), name='category-update'),
    path('api/category/delete/<str:id>/', operation.views.CategoryDeleteView.as_view(), name='category-delete'),
    
    # Gestion des statuts d'annonce
    path('api/announcement_status/', operation.views.AnnoucementStatusListView.as_view(), name='AnnoucementStatus-list'),
    path('api/announcement_status/id/<str:id>/', operation.views.AnnoucementStatusDetailByIdView.as_view(), name='AnnoucementStatus-detail-by-id'),
    path('api/announcement_status/update/<str:id>/', operation.views.AnnoucementStatusUpdateView.as_view(), name='AnnoucementStatus-update'),
    path('api/announcement_status/delete/<str:id>/', operation.views.AnnoucementStatusDeleteView.as_view(), name='AnnoucementStatus-delete'),
    
    # Gestion des types de document
    path('api/type_document/', operation.views.TypeDocumentListView.as_view(), name='TypeDocument-list'),
    path('api/type_document/id/<str:id>/', operation.views.TypeDocumentDetailByIdView.as_view(), name='TypeDocument-detail-by-id'),
    path('api/type_document/update/<str:id>/', operation.views.TypeDocumentUpdateView.as_view(), name='TypeDocument-update'),
    path('api/type_document/delete/<str:id>/', operation.views.TypeDocumentDeleteView.as_view(), name='TypeDocument-delete'),
    
    # Gestion des types de statistiques
    path('api/type_stat/', operation.views.TypeStatListView.as_view(), name='TypeStat-list'),
    path('api/type_stat/id/<str:id>/', operation.views.TypeStatDetailByIdView.as_view(), name='TypeStat-detail-by-id'),
    path('api/type_stat/update/<str:id>/', operation.views.TypeStatUpdateView.as_view(), name='TypeStat-update'),
    path('api/type_stat/delete/<str:id>/', operation.views.TypeStatDeleteView.as_view(), name='TypeStat-delete'),
    
    # Gestion des statuts de réservation
    path('api/booking_status/', operation.views.BookingStatusListView.as_view(), name='booking_status-list'),
    path('api/booking_status/id/<str:id>/', operation.views.BookingStatusDetailByIdView.as_view(), name='booking_status-detail-by-id'),
    path('api/booking_status/update/<str:id>/', operation.views.BookingStatusUpdateView.as_view(), name='booking_status-update'),
    path('api/booking_status/delete/<str:id>/', operation.views.BookingStatusDeleteView.as_view(), name='booking_status-delete'),
    
    # Gestion des types de visibilité
    path('api/type_visibility/', operation.views.TypeVisibilityListView.as_view(), name='type_visibility-list'),
    path('api/type_visibility/id/<str:id>/', operation.views.TypeVisibilityDetailByIdView.as_view(), name='type_visibility-detail-by-id'),
    path('api/type_visibility/update/<str:id>/', operation.views.TypeVisibilityUpdateView.as_view(), name='type_visibility-update'),
    path('api/type_visibility/delete/<str:id>/', operation.views.TypeVisibilityDeleteView.as_view(), name='type_visibility-delete'),
    
    # Gestion des types génériques
    path('api/type/', operation.views.TypeListView.as_view(), name='type-list'),
    path('api/type/id/<str:id>/', operation.views.TypeDetailByIdView.as_view(), name='type-detail-by-id'),
    path('api/type/update/<str:id>/', operation.views.TypeUpdateView.as_view(), name='type-update'),
    path('api/type/delete/<str:id>/', operation.views.TypeDeleteView.as_view(), name='type-delete'),
    
    # Gestion des réservations
    path('api/bookings/', operation.views.BookingListCreateView.as_view(), name='booking-list-create'),
    path('api/bookings/<str:id>/', operation.views.BookingDetailView.as_view(), name='booking-detail'),
    path('api/bookings/update/<str:id>/', operation.views.BookingUpdateView.as_view(), name='booking-update'),
    path('api/bookings/delete/<str:id>/', operation.views.BookingDeleteView.as_view(), name='booking-delete'),
    
    # Gestion des statuts KYC
    path('api/kycstatus/', operation.views.KycStatusListView.as_view(), name='kycstatus-list'),
    path('api/kycstatus/id/<str:id>/', operation.views.KycStatusDetailByIdView.as_view(), name='kycstatus-detail-by-id'),
    path('api/kycstatus/update/<str:id>/', operation.views.KycStatusUpdateView.as_view(), name='kycstatus-update'),
    path('api/kycstatus/delete/<str:id>/', operation.views.KycStatusDeleteView.as_view(), name='kycstatus-delete'),
    
    # Gestion des annonces
    path('api/announcements/', operation.views.AnnouncementListCreateView.as_view(), name='announcement-list-create'),
    path('api/announcements/<str:id>/', operation.views.AnnouncementDetailView.as_view(), name='announcement-detail'),
    path('api/announcements/<str:id>/update/', operation.views.AnnouncementUpdateView.as_view(), name='announcement-update'),
    path('api/announcements/<str:id>/delete/', operation.views.AnnouncementDeleteView.as_view(), name='announcement-delete'),
    
    # NOUVEAUX ENDPOINTS POUR COMPLÉTER L'APPLICATION
    
    # Système de vérification KYC
    path('api/documents/upload/', operation.views.DocumentUploadView.as_view(), name='document-upload'),
    path('api/verification/submit/', operation.views.UserVerificationView.as_view(), name='verification-submit'),
    path('api/admin/verification/', operation.views.AdminVerificationView.as_view(), name='admin-verification'),
    
    # Gestion des avis/ratings
    # path('api/ratings/', operation.views.RatingListCreateView.as_view(), name='rating-list-create'),
    # path('api/ratings/<str:id>/', operation.views.RatingDetailView.as_view(), name='rating-detail'),
    # path('api/ratings/update/<str:id>/', operation.views.RatingUpdateView.as_view(), name='rating-update'),
    # path('api/ratings/delete/<str:id>/', operation.views.RatingDeleteView.as_view(), name='rating-delete'),
    
    # # Gestion des images d'annonces
    # path('api/announcement-pictures/', operation.views.AnnouncementPictureListCreateView.as_view(), name='announcement-picture-list-create'),
    # path('api/announcement-pictures/<str:id>/', operation.views.AnnouncementPictureDetailView.as_view(), name='announcement-picture-detail'),
    # path('api/announcement-pictures/delete/<str:id>/', operation.views.AnnouncementPictureDeleteView.as_view(), name='announcement-picture-delete'),
    
    # # Gestion de l'historique
    # path('api/history/', notification.views.HistoryListView.as_view(), name='history-list'),
    
    # # Endpoints pour les statistiques détaillées des annonces
    # path('api/announcements/<str:id>/statistics/', operation.views.AnnouncementStatisticsView.as_view(), name='announcement-statistics'),
]