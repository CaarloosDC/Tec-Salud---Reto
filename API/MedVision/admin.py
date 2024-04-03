from django.contrib import admin
from .models import BodyPart, DoableProcedure, Step

class StepInline(admin.TabularInline):  # Puedes usar admin.StackedInline si prefieres un estilo diferente
    model = Step
    extra = 3  # Cuántos formularios de paso vacíos mostrar por defecto
    exclude = ('order',)  # Excluye el campo 'order' de la interfaz de administración

class DoableProcedureAdmin(admin.ModelAdmin):
    inlines = [StepInline]

    def save_formset(self, request, form, formset, change):
        instances = formset.save(commit=False)
        for i, instance in enumerate(instances):
            instance.order = i + 1
            instance.save()
        formset.save_m2m()

# Register your models here.
admin.site.register(BodyPart)
admin.site.register(DoableProcedure, DoableProcedureAdmin)
admin.site.register(Step)