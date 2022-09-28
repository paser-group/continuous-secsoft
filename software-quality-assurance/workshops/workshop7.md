## Workshop Name: Secret Management with Hashicorp Vault 

## Description 

Develop a Python script to automatically manage secrets with Hashicorp Vault 
 
## Targeted Courses 

Software Quality Assurance 

## Activities 

### Pre-lab Content Dissemination 

Secrets in software development can have detrimental consequences if obtained by unauthorized actors.  According to the Common Weakness Enumeration (CWE) organization, *Hard-coded credentials typically create a significant hole that allows an attacker to bypass the authentication that has been configured by the software administrator. This hole might be difficult for the system administrator to detect. Even if detected, it can be difficult to fix, so the administrator may be forced into disabling the product entirely.* ([CWE-798])(https://cwe.mitre.org/data/definitions/798.html)

Practitioners have developed a set of tools to manage secrets. One of the most popular tool is [Hashicorp Vault](https://www.vaultproject.io/) that helps practitioners in managing secrets programmatically. We will be using the open source version of Hashicorp Vault (HCP Vault) to store and retrieve secrets.  

### In-class Hands-on Experience 

We will be following an existing [tutorial](https://learn.hashicorp.com/tutorials/vault/getting-started-install?in=vault/getting-started) provided by HCP Vault. 

#### Installation of Hashicorp Vault and Relevant API

The following installation steps works for MacOS: 

- `brew tap hashicorp/tap` 
- `brew install hashicorp/tap/vault` 

Verify the HCP Vault installation: 

- `vault` 

Start the HCP Vault server. This will help us to programmatically store secrets 

- `vault server -dev` 

Keep an eye on the output of `vault server -dev` . From the output we will use `address` and `token` 

#### Install Relevant Python API

We will use an API called [HVAC](https://pypi.org/project/hvac/)

- `pip install hvac`

#### Develop a Python script with HVAC 

- First import necessary libraries 

```
import hvac
```

- Then, establish connection. Use URL and token from the output of `vault server -dev`: 

```
hvc_client = hvac.Client(url='YOUR_IP_ADDRESS', token='<YOUR_TOKEN>' )
```

- Now, store a secret inside HCP Vault using the `create_or_update_secret` method: 

```
create_response = hvc_client.secrets.kv.v2.create_or_update_secret(path='secret-path-1', secret=dict(password='Hashi123'),
)

Here *Hashi123* is the secret that we want to store. *secret-path-1* is the identifier that we will use to store the secret. 
```

- Let us retrieve the secret from the HCP Vault 

```
read_response      = hvc_client.secrets.kv.read_secret_version(path='secret-path-1')
secret_from_vault  = read_response['data']['data']['password']
print(secret_from_vault)
```

### Assignment 7 (Post Lab Experience) 

- Store the following secrets in your Hashicorp Vault using the HCP Vault Python API (`hvac`): 
  - `root_user` 
  - `test_password` 
  - `ghp_ahAyHoRwoQ`
  - `MTIzANO=` 
  - `t5f28U`
- Feel free to use the code shared by the instructor, i.e., `workshop7.py`  
- Submit your Python file and output @ Workshop 7 on CANVAS. (75%)
- Complete the [survey](https://auburn.qualtrics.com/jfe/form/SV_5hYDSu9P9jAMZWm):  (25%)
- Due: Oct 17, 2022 