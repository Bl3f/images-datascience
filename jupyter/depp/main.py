import requests
import os
import boto3
import xml.etree.ElementTree as ET


def get_minio_client(project_id):
    base_url = f"https://{project_id}.idee.depp.in.adc.education.fr"
    minio_url = "https://minio-idee.depp.in.adc.education.fr/"
    headers = {
        'Authorization': 'token %s' % os.environ["JPY_API_TOKEN"]
    }

    r = requests.get(os.path.join(base_url, "hub/api/user"), headers=headers)
    username = r.json()["name"]

    r = requests.get(os.path.join(base_url, "hub/api/users", username), headers=headers)
    minio_token = r.json()["auth_state"]["exchanged_tokens"]["minio"]

    data = requests.post(
        minio_url,
        headers={"Content-Type": "application/x-www-form-urlencoded"},
        data={
            "Action": "AssumeRoleWithWebIdentity",
            "Version": "2011-06-15",
            "DurationSeconds": "86000",
            "WebIdentityToken": minio_token,
        },
    )

    root = ET.fromstring(data.content)

    creds = root[0].findall('{https://sts.amazonaws.com/doc/2011-06-15/}Credentials')[0]
    accessKeyId = creds.find('{https://sts.amazonaws.com/doc/2011-06-15/}AccessKeyId').text
    secretAccessKey = creds.find('{https://sts.amazonaws.com/doc/2011-06-15/}SecretAccessKey').text
    sessionToken = creds.find('{https://sts.amazonaws.com/doc/2011-06-15/}SessionToken').text
    expiration = creds.find('{https://sts.amazonaws.com/doc/2011-06-15/}Expiration').text

    s3_client = boto3.client(
        's3',
        endpoint_url=minio_url,
        aws_access_key_id=accessKeyId,
        aws_secret_access_key=secretAccessKey,
        aws_session_token=sessionToken,
        config=boto3.session.Config(signature_version='s3v4'),
        verify=True,
    )

    return s3_client
