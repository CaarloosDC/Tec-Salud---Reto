from rest_framework import serializers
from .models import BodyPart, DoableProcedure, Step

class StepSerializer(serializers.ModelSerializer):
    image = serializers.ImageField(use_url=True, required=False)

    class Meta:
        model = Step
        fields = ['id', 'description', 'image', 'order', 'shortDescription']


class DoableProcedureSerializer(serializers.ModelSerializer):
    steps = StepSerializer(many=True, read_only=True)

    class Meta:
        model = DoableProcedure
        fields = ['pk','surgeryTechnicalName', 'description', 'steps']

class BodyPartSerializer(serializers.ModelSerializer):
    # procedures = DoableProcedureSerializer(many=True, read_only=True)  # 'procedures' es el related_name en el modelo
    image = serializers.ImageField(use_url=True)
    class Meta:
        model = BodyPart
        fields = ['id', 'medicalName', 'image', 'renderName']
