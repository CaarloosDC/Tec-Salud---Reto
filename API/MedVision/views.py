from rest_framework import viewsets
from .models import BodyPart, DoableProcedure, Step
from .serializer import BodyPartSerializer

# Create your views here.
class BodyPartViewSet(viewsets.ModelViewSet):
    serializer_class = BodyPartSerializer
    queryset = BodyPart.objects.all()
