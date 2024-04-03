import json
import os

# JSON input data
json_file_path = '/Users/carlosdc/Tec-Salud---Reto/API/JSONtoPlaneJSON.py'
with open(json_file_path, 'r') as file:
    nested_json = json.load(file)

# Convert the nested JSON to flat format for Django 'loaddata' command
flat_json = []
procedure_pk_counter = 1
step_pk_counter = 1

for bodypart in nested_json:
    # Append the bodypart itself
    flat_json.append({
        "model": "MedVision.bodypart",
        "pk": bodypart["id"],
        "fields": {
            "medicalName": bodypart["medicalName"],
            "imageName": bodypart["imageName"],
            "renderName": bodypart["renderName"]
        }
    })
    
    # Append the procedures related to the bodypart
    for procedure in bodypart["procedures"]:
        flat_json.append({
            "model": "MedVision.doableprocedure",
            "pk": procedure["surgeryTechnicalName"],
            "fields": {
                "bodyPart": bodypart["id"],
                "description": procedure["description"]
            }
        })
        
        # Append the steps related to the procedure
        for step in procedure["steps"]:
            flat_json.append({
                "model": "MedVision.step",
                "pk": step_pk_counter,
                "fields": {
                    "procedure": procedure["surgeryTechnicalName"],
                    "order": step["order"],
                    "description": step["description"],
                    "imageName": step["imageName"]
                }
            })
            step_pk_counter += 1

# Output the flat JSON
flat_json_str = json.dumps(flat_json, indent=2)
print(flat_json_str)
