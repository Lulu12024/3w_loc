from rest_framework import serializers
from operation.models import *
import base64
import uuid
from django.core.files.base import ContentFile
from authentication.serializers import UserSerializer
######################################################################
########## BASE 64 ################################################

class Base64ImageField(serializers.ImageField):
    def to_internal_value(self, base64_data):
        # Check if base64 string contains metadata (e.g., 'data:image/jpeg;base64,')
        if ';base64,' in base64_data:
            header, base64_data = base64_data.split(';base64,')
            
        try:
            # Decode the base64 string
            decoded_file = base64.b64decode(base64_data)
        except Exception as e:
            raise serializers.ValidationError(f"Invalid base64 encoding: {str(e)}")

        # Generate a unique filename
        file_extension = base64_data.split(';')[0].split('/')[-1]
        file_name = f"{uuid.uuid4()}.{file_extension}"

        # Create a ContentFile from the decoded data
        file = ContentFile(decoded_file, name=file_name)
        return super().to_internal_value(file)

###################################################################
class CategorySerializer(serializers.ModelSerializer):
    class Meta:
        model = Category
        fields = '__all__'

class AnnoucementStatusSerializer(serializers.ModelSerializer):
    class Meta:
        model = AnnoucementStatus
        fields = '__all__'

class TypeDocumentSerializer(serializers.ModelSerializer):
    class Meta:
        model = TypeDocument
        fields = '__all__'

class TypeStatSerializer(serializers.ModelSerializer):
    class Meta:
        model = TypeStat
        fields = '__all__'

class SubCategorySerializer(serializers.ModelSerializer):
    class Meta:
        model = SubCategory
        fields = '__all__'


class BookingStatusSerializer(serializers.ModelSerializer):
    class Meta:
        model = BookingStatus
        fields = '__all__'

class TypeVisibilitySerializer(serializers.ModelSerializer):
    class Meta:
        model = TypeVisibility
        fields = '__all__'

class TypeSerializer(serializers.ModelSerializer):
    class Meta:
        model = Type
        fields = '__all__'



class AnnouncementPictureSerializer(serializers.ModelSerializer):
    class Meta:
        model = AnnouncementPicture
        fields = ['id', 'announcement', 'image']

class AnnouncementSerializer(serializers.ModelSerializer):
    pictures = AnnouncementPictureSerializer(many=True, read_only=True)
    status_wording = serializers.CharField(source='status.wording', read_only=True)
    proprietaire_username = serializers.CharField(source='proprietaire.username', read_only=True)
    category_wording = serializers.CharField(source='category.wording', read_only=True)

    class Meta:
        model = Announcement
        fields = [
            'id', 'title', 'description', 'rental_price', 
            'status', 'status_wording', 'availability_startDate', 
            'availability_endDate', 'expiration_date', 
            'category', 'category_wording', 'rental_terms', 
            'location', 'extra_options', 'proprietaire', 
            'proprietaire_username', 'pictures'
        ]
        read_only_fields = ['id', 'status']

class AnnouncementCreateSerializer(serializers.ModelSerializer):
    images = Base64ImageField(
        write_only=True, 
        required=False, 
        # many=True
    )

    class Meta:
        model = Announcement
        fields = [
            'id', 'title', 'description', 'rental_price', 
            'availability_startDate', 'availability_endDate', 
            'expiration_date', 'category', 'rental_terms', 
            'location', 'extra_options', 'proprietaire', 
            'images'  
        ]
        extra_kwargs = {
            'id': {'read_only': True},
        }

    def create(self, validated_data):
        images = validated_data.pop('images', [])
        
        initial_status = AnnoucementStatus.objects.first()
        if not initial_status:
            raise serializers.ValidationError("No initial announcement status found")
        
        validated_data['status'] = initial_status
        announcement = Announcement.objects.create(**validated_data)
        
        
        for image in images:
            AnnouncementPicture.objects.create(
                announcement=announcement, 
                image=image
            )
        
        return announcement

    def update(self, instance, validated_data):
        images = validated_data.pop('images', [])
        
        
        for attr, value in validated_data.items():
            setattr(instance, attr, value)
        instance.save()
        
        for image in images:
            AnnouncementPicture.objects.create(
                announcement=instance, 
                image=image
            )
        
        return instance
    

class SubscriptionSerializer(serializers.ModelSerializer):
    type_visibility = TypeVisibilitySerializer(read_only=True)
    user = UserSerializer(read_only=True)

    class Meta:
        model = Subscription
        fields = [
            'id', 'wording', 'nbre_annoucement', 'type_visibility', 
            'duree_publication', 'user', 'created_at', 'updated_at'
        ]

class InvoiceSerializer(serializers.ModelSerializer):
    subscription = SubscriptionSerializer(read_only=True)
    user = UserSerializer(read_only=True)

    class Meta:
        model = Invoice
        fields = ['id', 'user', 'subscription', 'startDate', 'endDate']


class BookingSerializer(serializers.ModelSerializer):
    class Meta:
        model = Booking
        fields = '__all__'
        
class TypeSerializer(serializers.ModelSerializer):
    class Meta:
        model = Type
        fields = ['id', 'wording']


class KycStatusSerializer(serializers.ModelSerializer):
    class Meta:
        model = KycStatus
        fields = '__all__'

class DocumentSerializer(serializers.ModelSerializer):
    type_name = serializers.SerializerMethodField()
    
    class Meta:
        model = Document
        fields = '__all__'
        read_only_fields = ['user', 'created_at', 'updated_at']
    
    def get_type_name(self, obj):
        return obj.type.wording