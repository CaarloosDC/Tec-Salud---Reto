from django.core.management.base import BaseCommand
import json 
from MedVision.models import BodyPart, DoableProcedure, Step
class Command(BaseCommand):
    help = 'Load data from a json file into DB'

    def add_arguments(self, parser):
        parser.add_argument('json_file', type = str, help = 'The json file to load data from')
    
    def handle(self, *args, **kwargs):
        json_file = kwargs['json_file']
        with open(json_file, 'r') as f:
            data = json.load(f)
            for item in data:
                body_part = BodyPart.objects.create(
                    id = item['id'],
                    medicalName = item['medicalName'],
                    imageName = item['imageName'],
                    renderName = item['renderName']
                )
                for procedure in item['procedures']:
                    doable_procedure = DoableProcedure.objects.create(
                        bodyPart = body_part,
                        surgeryTechnicalName = procedure['surgeryTechnicalName'],
                        description = procedure['description']
                    )
                    for step in procedure['steps']:
                        Step.objects.create(
                            procedure = doable_procedure,
                            order = step['order'],
                            description = step['description'],
                            imageName = step['imageName']
                        )