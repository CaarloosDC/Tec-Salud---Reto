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
        fields = ['id', 'medicalName', 'image', 'render']

    def create(self, validated_data):
        return BodyPart.objects.create(**validated_data)

    def update(self, instance, validated_data):
        instance.id = validated_data.get('id', instance.id)
        instance.medicalName = validated_data.get('medicalName', instance.medicalName)
        instance.image = validated_data.get('image', instance.image)
        instance.render = validated_data.get('render', instance.render)
        instance.save()
        return instance
