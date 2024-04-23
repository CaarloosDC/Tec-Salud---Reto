from fastapi import FastAPI
from supabase import create_client, Client

app = FastAPI()
url = "https://wbrjxjdxqmgkmyspieqm.supabase.co"
key = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Indicmp4amR4cW1na215c3BpZXFtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTI2OTI4MTAsImV4cCI6MjAyODI2ODgxMH0.YElevblF7eWxueztkU2OsrFo8mGyIo-on5bmtWNLDc0"
supabase: Client = create_client(url, key)

@app.get("/getall")
def get_all():
    # Fetch data from bodyparts table
    bodyparts_response = supabase.table("bodyparts").select("*").execute()
    procedures_response = supabase.table("procedures").select("*").execute()
    steps_response = supabase.table("procedure_steps").select("*").execute()

    # Check for errors in responses
    if getattr(bodyparts_response, 'error', None):
        raise Exception(bodyparts_response.error)
    if getattr(procedures_response, 'error', None):
        raise Exception(procedures_response.error)
    if getattr(steps_response, 'error', None):
        raise Exception(steps_response.error)

    # Organize procedures by bodypart
    procedures = {p['id']: p for p in procedures_response.data}
    procedure_steps = {s['procedure_id']: [] for s in steps_response.data}
    for step in steps_response.data:
        procedure_steps[step['procedure_id']].append(step)

    # Organize data into the desired structure
    result = []
    for bodypart in bodyparts_response.data:
        bodypart_dict = {
            "id": bodypart['name'],
            "medicalName": bodypart['medical_name'],
            "imageName": bodypart['image_name'],
            "renderName": bodypart['render_name'],
            "doableProcedures": []
        }
        # Append procedures and their steps
        for procedure in procedures_response.data:
            if procedure['bodypart_id'] == bodypart['id']:
                procedure_dict = {
                    "id": procedure['id'],
                    "surgeryTechnicalName": procedure['name'],
                    "description": procedure['description'],
                    "steps": []
                }
                for step in procedure_steps.get(procedure['id'], []):
                    step_dict = {
                        "id": step['step_no'],
                        "description": step['description'],
                        "shortDescription": step['detailed_description'],
                        "imageName": step['image'],
                        "videoName": step['video']
                    }
                    procedure_dict["steps"].append(step_dict)
                bodypart_dict["doableProcedures"].append(procedure_dict)
        result.append(bodypart_dict)

    return result
