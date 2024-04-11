from django.db import models
from django.utils.deconstruct import deconstructible
from django.dispatch import receiver
from django.db.models.signals import post_delete
import os

# Create your models here.

@deconstructible
class UploadToPathAndRename(object):
    def __init__(self, path):
        self.sub_path = path

    def __call__(self, instance, filename):
        # Obtener la extensión del archivo original
        ext = filename.split('.')[-1]
        # Definir el nombre del archivo usando el ID del objeto, si está disponible
        if instance.id:
            filename = '{}.{}'.format(instance.id, ext)
        else:
            # Si el objeto aún no tiene un ID, puedes usar un nombre temporal o dejarlo con el nombre original
            # Esto último puede no ser ideal, ya que el nombre no se actualizará al ID una vez que el objeto sea guardado
            # Una opción sería manejarlo de manera especial en el método save del modelo
            filename = filename
        # Devolver la ruta completa del archivo
        return os.path.join(self.sub_path, filename)

def upload_to(instance, filename):
    ext = filename.split('.')[-1]
    base = 'media/images/' if isinstance(instance, BodyPart) and ext in ['jpg', 'jpeg', 'png', 'webp'] else 'media/renders/'
    filename = '{}.{}'.format(instance.id if instance.id else 'temp', ext)
    return os.path.join(base, filename)


class BodyPart(models.Model):
    id = models.CharField(primary_key=True, max_length=20)
    medicalName = models.CharField(max_length=25)
    image = models.ImageField(upload_to=upload_to)
    render = models.FileField(upload_to=upload_to, null=True, blank=True)  # Campo para el archivo .usdz

    def __str__(self):
        return self.medicalName

    def save(self, *args, **kwargs):
        # Lógica para manejar la actualización o eliminación de imágenes y archivos .usdz
        if self.pk:
            try:
                old_instance = BodyPart.objects.get(pk=self.pk)
                if old_instance.image and self.image and old_instance.image != self.image:
                    if os.path.isfile(old_instance.image.path):
                        os.remove(old_instance.image.path)
                if old_instance.render and self.render and old_instance.render != self.render:
                    if os.path.isfile(old_instance.render.path):
                        os.remove(old_instance.render.path)
            except BodyPart.DoesNotExist:
                pass
        super(BodyPart, self).save(*args, **kwargs)

@receiver(post_delete, sender=BodyPart)
def submission_delete(sender, instance, **kwargs):
    if instance.image:
        if os.path.isfile(instance.image.path):
            os.remove(instance.image.path)
    if instance.render:
        if os.path.isfile(instance.render.path):
            os.remove(instance.render.path)

class DoableProcedure(models.Model):
    bodyPart = models.ForeignKey(BodyPart, on_delete=models.CASCADE, related_name='procedures')
    surgeryTechnicalName = models.CharField(max_length=50, primary_key=True)
    description = models.TextField(max_length=255)

    def __str__(self):
        return self.surgeryTechnicalName

class Step(models.Model):
    procedure = models.ForeignKey(DoableProcedure, on_delete=models.CASCADE, related_name='steps') #Foreign key
    order = models.IntegerField(default=0)  # Campo adicional para el orden
    description = models.TextField()
    shortDescription = models.TextField(max_length=255,  blank=True, default='')
    imageName = models.CharField(max_length=255, blank=True, default='')

    class Meta:
        ordering = ['order']  # Ordena los pasos automáticamente por el campo 'order'

    def __str__(self):
        return f"{self.order}. {self.description[:50]}"  # Muestra el orden y parte de la descripción
    
