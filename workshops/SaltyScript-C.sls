# Переменные
{% set timeout = '60' %}
# Корневой путь до states
{% set file_roots = '/srv/salt' %}
# Корневой путь до pillars
{% set pillar_roots = '/srv/salt/pillars' %}

{% set HOSTNAMES = ['localhost', 'localhost.localdomain', 'localhost4', 'localhost4.localdomain4', 'salt', grains['fqdn']] %}
{% set IP = '127.0.0.1' %}
{{sls}}-{{IP}}-{{HOSTNAMES | first}}:
  host.present:
    - ip: {{IP}}
    - names:
      {% for HOSTNAME in HOSTNAMES %}
      - {{HOSTNAME}}
      {% endfor %}
    - clean: True
    - order: first

{% set HOSTNAMES = ['localhost6', 'localhost6.localdomain6'] %}
{{sls}}-:11-{{HOSTNAMES | first}}:
  host.absent:
    - ip: '::1'
    - names:
      {% for HOSTNAME in HOSTNAMES %}
      - {{HOSTNAME}}
      {% endfor %}
    - order: first

{% set pkg = 'epel-release' %}
{{sls}}-epel-release:
  pkg.installed:
    - pkgs:
      - {{pkg}}

{% set file_1 = '/etc/pki/rpm-gpg/centos7-signing-key' %}
{% set user = 'root' %}
{% set group = 'root' %}
{% set mode = '644' %}
{{sls}}-file-{{file_1}}:
  file.managed:
    - name: {{file_1}}
    - user: {{user}}
    - group: {{group}}
    - mode: {{mode}}
    - contents: |
        -----BEGIN PGP PUBLIC KEY BLOCK-----
        Version: GnuPG v1.4.5 (GNU/Linux)

        mQINBFOn/0sBEADLDyZ+DQHkcTHDQSE0a0B2iYAEXwpPvs67cJ4tmhe/iMOyVMh9
        Yw/vBIF8scm6T/vPN5fopsKiW9UsAhGKg0epC6y5ed+NAUHTEa6pSOdo7CyFDwtn
        4HF61Esyb4gzPT6QiSr0zvdTtgYBRZjAEPFVu3Dio0oZ5UQZ7fzdZfeixMQ8VMTQ
        4y4x5vik9B+cqmGiq9AW71ixlDYVWasgR093fXiD9NLT4DTtK+KLGYNjJ8eMRqfZ
        Ws7g7C+9aEGHfsGZ/SxLOumx/GfiTloal0dnq8TC7XQ/JuNdB9qjoXzRF+faDUsj
        WuvNSQEqUXW1dzJjBvroEvgTdfCJfRpIgOrc256qvDMp1SxchMFltPlo5mbSMKu1
        x1p4UkAzx543meMlRXOgx2/hnBm6H6L0FsSyDS6P224yF+30eeODD4Ju4BCyQ0jO
        IpUxmUnApo/m0eRelI6TRl7jK6aGqSYUNhFBuFxSPKgKYBpFhVzRM63Jsvib82rY
        438q3sIOUdxZY6pvMOWRkdUVoz7WBExTdx5NtGX4kdW5QtcQHM+2kht6sBnJsvcB
        JYcYIwAUeA5vdRfwLKuZn6SgAUKdgeOtuf+cPR3/E68LZr784SlokiHLtQkfk98j
        NXm6fJjXwJvwiM2IiFyg8aUwEEDX5U+QOCA0wYrgUQ/h8iathvBJKSc9jQARAQAB
        tEJDZW50T1MtNyBLZXkgKENlbnRPUyA3IE9mZmljaWFsIFNpZ25pbmcgS2V5KSA8
        c2VjdXJpdHlAY2VudG9zLm9yZz6JAjUEEwECAB8FAlOn/0sCGwMGCwkIBwMCBBUC
        CAMDFgIBAh4BAheAAAoJECTGqKf0qA61TN0P/2730Th8cM+d1pEON7n0F1YiyxqG
        QzwpC2Fhr2UIsXpi/lWTXIG6AlRvrajjFhw9HktYjlF4oMG032SnI0XPdmrN29lL
        F+ee1ANdyvtkw4mMu2yQweVxU7Ku4oATPBvWRv+6pCQPTOMe5xPG0ZPjPGNiJ0xw
        4Ns+f5Q6Gqm927oHXpylUQEmuHKsCp3dK/kZaxJOXsmq6syY1gbrLj2Anq0iWWP4
        Tq8WMktUrTcc+zQ2pFR7ovEihK0Rvhmk6/N4+4JwAGijfhejxwNX8T6PCuYs5Jiv
        hQvsI9FdIIlTP4XhFZ4N9ndnEwA4AH7tNBsmB3HEbLqUSmu2Rr8hGiT2Plc4Y9AO
        aliW1kOMsZFYrX39krfRk2n2NXvieQJ/lw318gSGR67uckkz2ZekbCEpj/0mnHWD
        3R6V7m95R6UYqjcw++Q5CtZ2tzmxomZTf42IGIKBbSVmIS75WY+cBULUx3PcZYHD
        ZqAbB0Dl4MbdEH61kOI8EbN/TLl1i077r+9LXR1mOnlC3GLD03+XfY8eEBQf7137
        YSMiW5r/5xwQk7xEcKlbZdmUJp3ZDTQBXT06vavvp3jlkqqH9QOE8ViZZ6aKQLqv
        pL+4bs52jzuGwTMT7gOR5MzD+vT0fVS7Xm8MjOxvZgbHsAgzyFGlI1ggUQmU7lu3
        uPNL0eRx4S1G4Jn5
        =OGYX
        -----END PGP PUBLIC KEY BLOCK-----

{% set file_2 = '/etc/pki/rpm-gpg/saltstack-signing-key' %}
{% set user = 'root' %}
{% set group = 'root' %}
{% set mode = '644' %}
{{sls}}-file-{{file_2}}:
  file.managed:
    - name: {{file_2}}
    - user: {{user}}
    - group: {{group}}
    - mode: {{mode}}
    - contents: |
        -----BEGIN PGP PUBLIC KEY BLOCK-----
        Version: GnuPG v2.0.22 (GNU/Linux)

        mQENBFOpvpgBCADkP656H41i8fpplEEB8IeLhugyC2rTEwwSclb8tQNYtUiGdna9
        m38kb0OS2DDrEdtdQb2hWCnswxaAkUunb2qq18vd3dBvlnI+C4/xu5ksZZkRj+fW
        tArNR18V+2jkwcG26m8AxIrT+m4M6/bgnSfHTBtT5adNfVcTHqiT1JtCbQcXmwVw
        WbqS6v/LhcsBE//SHne4uBCK/GHxZHhQ5jz5h+3vWeV4gvxS3Xu6v1IlIpLDwUts
        kT1DumfynYnnZmWTGc6SYyIFXTPJLtnoWDb9OBdWgZxXfHEcBsKGha+bXO+m2tHA
        gNneN9i5f8oNxo5njrL8jkCckOpNpng18BKXABEBAAG0MlNhbHRTdGFjayBQYWNr
        YWdpbmcgVGVhbSA8cGFja2FnaW5nQHNhbHRzdGFjay5jb20+iQE4BBMBAgAiBQJT
        qb6YAhsDBgsJCAcDAgYVCAIJCgsEFgIDAQIeAQIXgAAKCRAOCKFJ3le/vhkqB/0Q
        WzELZf4d87WApzolLG+zpsJKtt/ueXL1W1KA7JILhXB1uyvVORt8uA9FjmE083o1
        yE66wCya7V8hjNn2lkLXboOUd1UTErlRg1GYbIt++VPscTxHxwpjDGxDB1/fiX2o
        nK5SEpuj4IeIPJVE/uLNAwZyfX8DArLVJ5h8lknwiHlQLGlnOu9ulEAejwAKt9CU
        4oYTszYM4xrbtjB/fR+mPnYh2fBoQO4d/NQiejIEyd9IEEMd/03AJQBuMux62tjA
        /NwvQ9eqNgLw9NisFNHRWtP4jhAOsshv1WW+zPzu3ozoO+lLHixUIz7fqRk38q8Q
        9oNR31KvrkSNrFbA3D89uQENBFOpvpgBCADJ79iH10AfAfpTBEQwa6vzUI3Eltqb
        9aZ0xbZV8V/8pnuU7rqM7Z+nJgldibFk4gFG2bHCG1C5aEH/FmcOMvTKDhJSFQUx
        uhgxttMArXm2c22OSy1hpsnVG68G32Nag/QFEJ++3hNnbyGZpHnPiYgej3FrerQJ
        zv456wIsxRDMvJ1NZQB3twoCqwapC6FJE2hukSdWB5yCYpWlZJXBKzlYz/gwD/Fr
        GL578WrLhKw3UvnJmlpqQaDKwmV2s7MsoZogC6wkHE92kGPG2GmoRD3ALjmCvN1E
        PsIsQGnwpcXsRpYVCoW7e2nW4wUf7IkFZ94yOCmUq6WreWI4NggRcFC5ABEBAAGJ
        AR8EGAECAAkFAlOpvpgCGwwACgkQDgihSd5Xv74/NggA08kEdBkiWWwJZUZEy7cK
        WWcgjnRuOHd4rPeT+vQbOWGu6x4bxuVf9aTiYkf7ZjVF2lPn97EXOEGFWPZeZbH4
        vdRFH9jMtP+rrLt6+3c9j0M8SIJYwBL1+CNpEC/BuHj/Ra/cmnG5ZNhYebm76h5f
        T9iPW9fFww36FzFka4VPlvA4oB7ebBtquFg3sdQNU/MmTVV4jPFWXxh4oRDDR+8N
        1bcPnbB11b5ary99F/mqr7RgQ+YFF0uKRE3SKa7a+6cIuHEZ7Za+zhPaQlzAOZlx
        fuBmScum8uQTrEF5+Um5zkwC7EXTdH1co/+/V/fpOtxIg4XO4kcugZefVm5ERfVS
        MA==
        =dtMN
        -----END PGP PUBLIC KEY BLOCK-----

{% set file_3 = '/etc/yum.repos.d/salt-py3-3000.repo' %}
{% set user = 'root' %}
{% set group = 'root' %}
{% set mode = '644' %}
{{sls}}-file-{{file_3}}:
  file.managed:
    - name: {{file_3}}
    - user: {{user}}
    - group: {{group}}
    - mode: {{mode}}
    - contents: |
        [salt-py3-3000]
        name=SaltStack 3000 Release Channel for Python 3 RHEL/Centos $releasever
        baseurl=https://repo.saltstack.com/py3/redhat/8/$basearch/3000
        failovermethod=priority
        enabled=1
        gpgcheck=1
        gpgkey=file:///etc/pki/rpm-gpg/saltstack-signing-key

{% set pkgs = ['salt-master', 'salt-ssh', 'salt-api', 'salt-minion', 'salt-syndic', 'salt-cloud', 'salt-api', 'git'] %}
{{sls}}-pkg-salt-master:
  pkg.installed:
    - require:
      - file: {{sls}}-file-{{file_1}}
      - file: {{sls}}-file-{{file_2}}
      - file: {{sls}}-file-{{file_3}}
    - pkgs:
      {% for pkg in pkgs %}
      - {{pkg}}
      {% endfor %}
    - refresh: True

{% set pkg = 'python3-pip' %}
{{sls}}-pkg-{{pkg}}:
  pkg.installed:
    - require:
      - pkg: {{sls}}-pkg-salt-master
    - pkgs:
      - {{pkg}}

{{sls}}-pip3-upgrade:
  cmd.run:
    - require:
      - pkg: {{sls}}-pkg-{{pkg}}
    - onlyif:
      - test `pip3 -V | cut -d' ' -f 2 | cut -d'.' -f 1` -lt 20
    - name: python3 -m pip install --upgrade --force-reinstall pip && rm -f /usr/local/bin/pip && mv -f /usr/local/bin/pip3.6 /usr/bin && mv -f /usr/local/bin/pip3 /usr/bin

{% set pkgs = ['python3-pycryptodomex', 'python3-smmap', 'python3-msgpack'] %}
{{sls}}-python-packages-via-dnf:
  pkg.installed:
    - require:
      - pkg: {{sls}}-pkg-salt-master
    - pkgs:
      {% for pkg in pkgs %}
      - {{pkg}}
      {% endfor %}

{% set pip_pkgs = ['pygit2', 'py-dateutil', 'Mako', 'python-gnupg', 'docker-py', 'progressbar'] %}
{{sls}}-pip-pkgs:
  pip.installed:
    - require:
      - cmd: {{sls}}-pip3-upgrade
    - names:
      {% for pip_pkg in pip_pkgs %}
      - {{pip_pkg}}
      {% endfor %}

{% set file_4 = '/etc/salt/master.d/cli_summary.conf' %}
{% set user = 'root' %}
{% set group = 'root' %}
{% set mode = '644' %}
{{sls}}-config-{{file_4}}:
  file.managed:
    - require:
      - pkg: {{sls}}-pkg-salt-master
    - name: {{file_4}}
    - user: {{user}}
    - group: {{group}}
    - mode: {{mode}}
    - contents: |
        cli_summary: True
{% set file_5 = '/etc/salt/master.d/file_recv.conf' %}
{% set user = 'root' %}
{% set group = 'root' %}
{% set mode = '644' %}
{{sls}}-config-{{file_5}}:
  file.managed:
    - require:
      - pkg: {{sls}}-pkg-salt-master
    - name: {{file_5}}
    - user: {{user}}
    - group: {{group}}
    - mode: {{mode}}
    - contents: |
        file_recv: True

{% set file_6 = '/etc/salt/master.d/output_format.conf' %}
{% set user = 'root' %}
{% set group = 'root' %}
{% set mode = '644' %}
{{sls}}-config-{{file_6}}:
  file.managed:
    - require:
      - pkg: {{sls}}-pkg-salt-master
    - name: {{file_6}}
    - user: {{user}}
    - group: {{group}}
    - mode: {{mode}}
    - contents: |
        #state_verbose: True
        state_output: changes
        #state_output_diff: False
        #state_aggregate: False
        state_events: True

{% set file_7 = '/etc/salt/master.d/states_local.conf' %}
{% set user = 'root' %}
{% set group = 'root' %}
{% set mode = '644' %}
{{sls}}-config-{{file_7}}:
  file.managed:
    - require:
      - pkg: {{sls}}-pkg-salt-master
    - name: {{file_7}}
    - user: {{user}}
    - group: {{group}}
    - mode: {{mode}}
    - contents: |
        file_roots:
          base:
            - {{file_roots}}

{% set file_8 = '/etc/salt/master.d/pillars_local.conf' %}
{% set user = 'root' %}
{% set group = 'root' %}
{% set mode = '644' %}
{{sls}}-config-{{file_8}}:
  file.managed:
    - require:
      - pkg: {{sls}}-pkg-salt-master
    - name: {{file_8}}
    - user: {{user}}
    - group: {{group}}
    - mode: {{mode}}
    - contents: |
        pillar_roots:
          base:
            - {{pillar_roots}}

{% set file_9 = '/etc/salt/master.d/timeout.conf' %}
{% set user = 'root' %}
{% set group = 'root' %}
{% set mode = '644' %}
{{sls}}-config-{{file_9}}:
  file.managed:
    - require:
      - pkg: {{sls}}-pkg-salt-master
    - name: {{file_9}}
    - user: {{user}}
    - group: {{group}}
    - mode: {{mode}}
    - contents: |
        timeout: {{timeout}}

{% set service = 'salt-master' %}
{{sls}}-service-{{service}}:
  service.running:
    - watch:
      - file: {{sls}}-config-{{file_4}}
      - file: {{sls}}-config-{{file_5}}
      - file: {{sls}}-config-{{file_6}}
      - file: {{sls}}-config-{{file_7}}
      - file: {{sls}}-config-{{file_8}}
      - file: {{sls}}-config-{{file_9}}
    - name: {{service}}
    - enable: true
    - restart: true
    - order: last

{% set file_10 = '/etc/salt/minion_id' %}
{% set user = 'root' %}
{% set group = 'root' %}
{% set mode = '644' %}
{{sls}}-config-{{file_10}}:
  file.managed:
    - require:
      - pkg: {{sls}}-pkg-salt-master
    - name: {{file_10}}
    - user: {{user}}
    - group: {{group}}
    - mode: {{mode}}
    - contents: |
        salt

{% set service = 'salt-minion' %}
{{sls}}-service-{{service}}:
  service.running:
    - watch:
      - file: {{sls}}-config-{{file_10}}
    - name: {{service}}
    - enable: true
    - full_restart: true
    - order: last

{% set service = 'salt-api' %}
{{sls}}-service-{{service}}:
  service.disabled:
    - name: {{service}}


{% set directory = file_roots %}
{% set user = 'root' %}
{% set group = 'root' %}
{% set mode = '755' %}
{{sls}}-directory-{{directory}}:
  file.directory:
    - name: {{directory}}
    - user: {{user}}
    - group: {{group}}
    - mode: {{mode}}

{% set directory = pillar_roots %}
{% set user = 'root' %}
{% set group = 'root' %}
{% set mode = '755' %}
{{sls}}-directory-{{directory}}:
  file.directory:
    - name: {{directory}}
    - user: {{user}}
    - group: {{group}}
    - mode: {{mode}}

{% set directory = '/srv/reactor' %}
{% set user = 'root' %}
{% set group = 'root' %}
{% set mode = '755' %}
{{sls}}-directory-{{directory}}:
  file.directory:
    - name: {{directory}}
    - user: {{user}}
    - group: {{group}}
    - mode: {{mode}}
