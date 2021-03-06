from flask import json
import requests

from Domain.Model.AssociationSkillDto import AssociationSkillDto
from Domain.Model.CompetenceRegistry import CompetenceRegistry
from Shared import Constants
from Shared.ObjectHandler import object_handler


def save_skills(skill_list, user_data):
    email = user_data.email
    password = user_data.password
    auth_string = "NLAuth nlauth_account={0}, nlauth_email={1}, nlauth_signature={2}"
    auth_header = auth_string.format(Constants.NLAUTH_ACCOUNT, email, password)
    headers = {"content-type": "application/json", "Authorization": auth_header}

    dict_lista_competencias = dict()

    dict_lista_competencias["listaCompetencias"] = json.dumps(skill_list, default=object_handler)

    json_lista_competencias = json.dumps(dict_lista_competencias, default=object_handler)

    request = requests.post(Constants.URL_NETSUITE.format(Constants.SCRIPT_COMPETENCIAS), data=json_lista_competencias, headers=headers)

    response = request.content

    return response


def update_skills(skill_list, user_data):
    email = user_data.email
    password = user_data.password
    auth_string = "NLAuth nlauth_account={0}, nlauth_email={1}, nlauth_signature={2}"
    auth_header = auth_string.format(Constants.NLAUTH_ACCOUNT, email, password)
    headers = {"content-type": "application/json", "Authorization": auth_header}

    dict_lista_competencias = dict()

    dict_lista_competencias["listaCompetencias"] = json.dumps(skill_list, default=object_handler)

    json_lista_competencias = json.dumps(dict_lista_competencias, default=object_handler)

    request = requests.post(Constants.URL_NETSUITE.format(Constants.SCRIPT_COMPETENCIAS), data=json_lista_competencias,
                            headers=headers)

    response = request.content

    return response


def list_user_skills(user_data):
    email = user_data.email
    password = user_data.password
    auth_string = "NLAuth nlauth_account={0}, nlauth_email={1}, nlauth_signature={2}"
    auth_header = auth_string.format(Constants.NLAUTH_ACCOUNT, email, password)
    headers = {"content-type": "application/json", "Authorization": auth_header}
    response = requests.get(Constants.URL_NETSUITE.format(Constants.SCRIPT_COMPETENCIAS)+'&id='+user_data.id, headers=headers)
    response_data = json.loads(response.text)
    response_data = json.loads(response_data)
    if "error" in response_data:
            return None

    registries = []

    for json_registry in response_data:
        competence = CompetenceRegistry(json_registry.get("id"), json_registry.get("categoria"), json_registry.get("nivelConhecimento"), json_registry.get("interesse"), json_registry.get("idMacro"), json_registry.get("idMicro"), json_registry.get("nomeMacro"), json_registry.get("nomeMicro"))
        registries.append(competence)

    return registries


def list_all_skills(user_data):
    email = user_data.email
    password = user_data.password
    auth_string = "NLAuth nlauth_account={0}, nlauth_email={1}, nlauth_signature={2}"
    auth_header = auth_string.format(Constants.NLAUTH_ACCOUNT, email, password)
    headers = {"content-type": "application/json", "Authorization": auth_header}
    response = requests.get(Constants.URL_NETSUITE.format(Constants.SCRIPT_RELACIONAL), headers=headers)
    response_data = json.loads(response.text)
    response_data = json.loads(response_data)
    if "error" in response_data:
        return None

    skills_data = []

    for json_skill in response_data:
        skill = AssociationSkillDto(json_skill.get("id"), json_skill.get("categoriaMacro"), json_skill.get("categoriaMicro"), json_skill.get("categoriaMacroTexto"), json_skill.get("categoriaMicroTexto"))
        skills_data.append(skill)

    return skills_data


def delete_skill(id_macro, funcionario, user_data):
    email = user_data.email
    password = user_data.password
    auth_string = "NLAuth nlauth_account={0}, nlauth_email={1}, nlauth_signature={2}"
    auth_header = auth_string.format(Constants.NLAUTH_ACCOUNT, email, password)
    headers = {"content-type": "application/json", "Authorization": auth_header}
    requests.delete(Constants.URL_NETSUITE.format(Constants.SCRIPT_COMPETENCIAS)+'&idMacro='+id_macro+'&funcionario='+funcionario, headers=headers)

    return ''
