from django.db import models

# Create your models here.

class BodyPart(models.Model):
    id = models.CharField(primary_key=True, max_length=7)
    medicalName = models.CharField(max_length=25)
    imageName = models.CharField(max_length=255)
    renderName = models.CharField(max_length=255)

    def __str__(self):
        return self.medicalName

class DoableProcedure(models.Model):
    bodyPart = models.ForeignKey(BodyPart, on_delete=models.CASCADE, related_name='procedures')
    surgeryTechnicalName = models.CharField(max_length=50, primary_key=True)
    description = models.TextField(max_length=255)

    def __str__(self):
        return self.surgeryTechnicalName

class Step(models.Model):
    procedure = models.ForeignKey(DoableProcedure, on_delete=models.CASCADE, related_name='steps')
    order = models.IntegerField(default=0)  # Campo adicional para el orden
    description = models.TextField(max_length=255)
    imageName = models.CharField(max_length=255, blank=True, default='')

    class Meta:
        ordering = ['order']  # Ordena los pasos automáticamente por el campo 'order'

    def __str__(self):
        return f"{self.order}. {self.description[:50]}"  # Muestra el orden y parte de la descripción