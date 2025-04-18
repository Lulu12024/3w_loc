# Generated by Django 5.1.3 on 2025-01-20 09:12

import django.contrib.auth.models
import django.contrib.auth.validators
import django.db.models.deletion
import django.utils.timezone
import uuid
from django.conf import settings
from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
        ('auth', '0012_alter_user_first_name_max_length'),
    ]

    operations = [
        migrations.CreateModel(
            name='Pays',
            fields=[
                ('id', models.UUIDField(default=uuid.uuid4, editable=False, primary_key=True, serialize=False)),
                ('wording', models.CharField(default='', max_length=255)),
                ('code', models.CharField(default='', max_length=255)),
            ],
        ),
        migrations.CreateModel(
            name='Role',
            fields=[
                ('id', models.UUIDField(default=uuid.uuid4, editable=False, primary_key=True, serialize=False)),
                ('libelle', models.CharField(default='', max_length=255)),
                ('description', models.CharField(default='', max_length=255)),
                ('is_deleted', models.BooleanField(default=False)),
            ],
        ),
        migrations.CreateModel(
            name='TypeDocument',
            fields=[
                ('id', models.UUIDField(default=uuid.uuid4, editable=False, primary_key=True, serialize=False)),
                ('wording', models.CharField(default='', max_length=255)),
            ],
        ),
        migrations.CreateModel(
            name='User',
            fields=[
                ('password', models.CharField(max_length=128, verbose_name='password')),
                ('last_login', models.DateTimeField(blank=True, null=True, verbose_name='last login')),
                ('is_superuser', models.BooleanField(default=False, help_text='Designates that this user has all permissions without explicitly assigning them.', verbose_name='superuser status')),
                ('username', models.CharField(error_messages={'unique': 'A user with that username already exists.'}, help_text='Required. 150 characters or fewer. Letters, digits and @/./+/-/_ only.', max_length=150, unique=True, validators=[django.contrib.auth.validators.UnicodeUsernameValidator()], verbose_name='username')),
                ('is_staff', models.BooleanField(default=False, help_text='Designates whether the user can log into this admin site.', verbose_name='staff status')),
                ('date_joined', models.DateTimeField(default=django.utils.timezone.now, verbose_name='date joined')),
                ('id', models.UUIDField(default=uuid.uuid4, editable=False, primary_key=True, serialize=False)),
                ('is_active', models.BooleanField(default=True)),
                ('is_deleted', models.BooleanField(default=False)),
                ('last_name', models.CharField(default='', max_length=255)),
                ('first_name', models.CharField(default='', max_length=255)),
                ('phone_number', models.CharField(default='', max_length=255)),
                ('birthdate', models.DateField(null=True)),
                ('civility', models.CharField(default='', max_length=255)),
                ('city', models.CharField(default='', max_length=255)),
                ('department', models.CharField(default='', max_length=255)),
                ('zip_code', models.CharField(default='', max_length=255)),
                ('main_address', models.CharField(default='', max_length=255)),
                ('secondary_address', models.CharField(default='', max_length=255)),
                ('email', models.EmailField(max_length=254, unique=True, verbose_name='email address')),
                ('type_compte', models.CharField(default='', max_length=255)),
                ('password_reset_token', models.CharField(blank=True, max_length=128, null=True)),
                ('password_reset_token_expiration', models.DateTimeField(blank=True, null=True)),
                ('user_code', models.CharField(max_length=7, unique=True)),
                ('photo_profil', models.ImageField(null=True, upload_to='document/photo_profil')),
                ('groups', models.ManyToManyField(blank=True, help_text='The groups this user belongs to. A user will get all permissions granted to each of their groups.', related_name='user_set', related_query_name='user', to='auth.group', verbose_name='groups')),
                ('user_permissions', models.ManyToManyField(blank=True, help_text='Specific permissions for this user.', related_name='user_set', related_query_name='user', to='auth.permission', verbose_name='user permissions')),
                ('country', models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.SET_NULL, to='authentication.pays')),
                ('role', models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.SET_NULL, related_name='users', to='authentication.role')),
            ],
            options={
                'ordering': ['-date_joined'],
            },
            managers=[
                ('objects', django.contrib.auth.models.UserManager()),
            ],
        ),
        migrations.CreateModel(
            name='Document',
            fields=[
                ('id', models.UUIDField(default=uuid.uuid4, editable=False, primary_key=True, serialize=False)),
                ('numero_document', models.CharField(default='', max_length=255)),
                ('user', models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.SET_NULL, to=settings.AUTH_USER_MODEL)),
                ('type', models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.SET_NULL, to='authentication.typedocument')),
            ],
        ),
    ]
