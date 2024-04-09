from rest_framework import serializers
from .models import BodyPart, DoableProcedure, Step

class StepSerializer(serializers.ModelSerializer):
    class Meta:
        model = Step
        fields = ['description', 'imageName', 'order']

class DoableProcedureSerializer(serializers.ModelSerializer):
    steps = StepSerializer(many=True, read_only=True)  # Asegúrate de que 'steps' es el related_name en el modelo

    class Meta:
        model = DoableProcedure
        fields = ['pk','surgeryTechnicalName', 'description', 'steps']

class BodyPartSerializer(serializers.ModelSerializer):
    procedures = DoableProcedureSerializer(many=True, read_only=True)  # 'procedures' es el related_name en el modelo

    class Meta:
        model = BodyPart
        fields = ['id', 'medicalName', 'imageName', 'renderName', 'procedures']
