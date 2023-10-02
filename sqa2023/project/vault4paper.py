from http import client
from itertools import count
from venv import create
import hvac 
import random 

'''
1. Install Vault 

- `brew tap hashicorp/tap` 
- `brew install hashicorp/tap/vault` 

2. Verify the HCP Vault installation: 

- `vault` 

3. Start the HCP Vault server. This will help us to programmatically store secrets 

- `vault server -dev` 

4. Keep an eye on the output of `vault server -dev` . From the output we will use `address` and `token` 

5. `pip install hvac`
'''

counter_mapper           = {}
hvac_token               = "REPLACE_THIS_WITH_YOUR_OWN" ## this should come from the output of *vault server -dev* 
hvac_url                 = "REPLACE_THIS_WITH_YOUR_OWN"        ## this should come from the output of *vault server -dev*
ansible_secret_retrieval = '"{{ lookup(' + "'hashi_vault', 'secret="  
puppet_secret_retrieval  = "Deferred('vault_lookup::lookup', ["  


def makeConn():
    hvc_client = hvac.Client(url= hvac_url, token= hvac_token) 
    return hvc_client 

def storeSecret( client,  secr1 , cnt  ):
    secret_path     = 'SECRET_PATH_' + str( cnt  )
    create_response = client.secrets.kv.v2.create_or_update_secret(path=secret_path, secret=dict(password =  secr1 ) )
    # print( type( create_response ) )
    # print( dir( create_response)  )

def retrieveSecret(client_, cnt_, tech_str): 
    secret_path        = 'SECRET_PATH_' + str( cnt_  )
    read_response      = client_.secrets.kv.read_secret_version(path=secret_path) 
    secret_from_vault  = read_response['data']['data']['password']
    # print('The secret we have obtained:')
    print("To retrieve the secret '{}' please plugin the following code snippet in your script:".format( secret_from_vault) )
    if tech_str == 'A': 
        print(ansible_secret_retrieval + secret_path + " token=" + hvac_token + " url=" + hvac_url + ")['data']['data']['password'] }}" + '"')
    elif tech_str == 'P':
        print(puppet_secret_retrieval + '"' + secret_path + '/' + hvac_token  + '", ' + hvac_url + "']),"  )



def preprocessTechInput(tech_str):
    str2ret = ''
    tech_str = tech_str.replace('\n', '')
    tech_str = tech_str.replace('\r', '')    

    str2ret  = tech_str 
    return str2ret


def storeSecrets(lis_secr, tech_str): 
    clientObj    =  makeConn() 
    for secret2store in lis_secr: 
        counter = random.randint(1, 100000)
        storeSecret( clientObj,   secret2store, counter )
        counter_mapper[counter] = tech_str
    print("Finished storing secrets!")
    print('='*50)    


def retrieveSecrets( tech_str ): 
    clientObj = makeConn() 
    for counter, v_ in counter_mapper.items():
        retrieveSecret( clientObj,  counter, tech_str )
    print('='*50)


if __name__ == '__main__': 
    print("Welcome!")
    print("This Python program will ask for inputs from you in order to store secrets and provide code to retrieve secrets.")
    print("First let's understand what technology are you using? Type 'A' for Ansible and 'P' for Puppet:")
    technology_string = input()
    preprocessTechInput( technology_string )
    print("Thanks. Please provide the secrets that you want this program to securely store:")
    inp_secret_holder = []
    while True: 
        print("Please provide the secret that you want the program to secure. Hit 'q' to quit:")
        secret = input() 
        secret = preprocessTechInput(secret)
        if secret == 'Q' or secret == 'q': 
            break
        inp_secret_holder.append( secret  )
    storeSecrets( inp_secret_holder, technology_string )
    print("Do you want the code snippet to retrieve your secrets? 'Y' for yes and 'N' for no.")
    retrieve = input()
    retrieve = preprocessTechInput( retrieve )
    if retrieve == 'Y' or retrieve == 'y': 
        retrieveSecrets( technology_string )
    elif retrieve == 'N' or retrieve == 'n': 
        print("Thanks for using the program. Goodbye!")

