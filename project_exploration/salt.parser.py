'''
Project Exploration 
Akond Rahman 
Aug 03, 2020 
'''

import yaml 
from yaml.composer import ComposerError
from yaml.scanner import ScannerError
from yaml.parser import  ParserError
from yaml.constructor import ConstructorError
from yaml.reader import ReaderError


def parseYAML(yaml_full_file_path):
    yaml_dict  = {}
    try:
        with open(yaml_full_file_path,  'r' ) as file_obj:
            yaml_dict = yaml.load(file_obj, Loader=yaml.FullLoader)    
    except ComposerError:
        print('YAML parsing error')
    except ScannerError:
        print('YAML parsing error')
    except ParserError:
        print('YAML parsing error')
    except ConstructorError:
        print('YAML parsing error')
    except ReaderError:
        print('YAML parsing error')
    return yaml_dict

if __name__ == '__main__':
    print(parseYAML( 'init.sls' ) ) 