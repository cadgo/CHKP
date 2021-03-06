FROM python:3
ENV PYTHONUNBUFFERED 1
ARG subscription_id
ARG client_id
ARG secret
ARG tenant
RUN mkdir /code
WORKDIR /code
RUN apt-get update -y && apt-get upgrade -y
RUN pip install ansible
RUN wget -O requirments.txt https://raw.githubusercontent.com/Azure/azure_modules/master/files/requirements-azure.txt
RUN pip install -r requirments.txt
RUN ansible-galaxy install azure.azure_modules
ADD . /code/
RUN wget https://raw.githubusercontent.com/ansible/ansible/devel/contrib/inventory/azure_rm.py
RUN wget https://raw.githubusercontent.com/ansible/ansible/devel/contrib/inventory/azure_rm.ini 
RUN chmod +x /code/azure_rm.py
RUN /code/config.sh $subscription_id $client_id $secret $tenant
ENV PATH "$PATH:/Terraform"
