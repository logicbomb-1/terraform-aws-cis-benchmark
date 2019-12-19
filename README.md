# terraform-aws-cis-benchmark
github-secret-scan is a Python tool to help find potentially sensitive data pushed to public or private repositories on Github. This can be used by organization to find sensitive data in thier public or private repositories and fix them accordingly. The tool also scans member's repositories. Moreover, the tool can also be used by security researchers to hunt for sensitive leaks in organization's public repositories along with thier members. 

## Installation

Use the package manager [pip](https://pip.pypa.io/en/stable/) to install foobar.

```bash
pip install requirements.txt
```

## Options
```
--orgname
    To specify the organization repository name. 
```    

## Usage

Clone this repository and run:
```bash
python gss.py --orgname [name of the organisation]

```

## Github access token
github-secret-scan will need a Github access token in order to interact with the Github API. Create a personal access token and save it in an environment variable in your .bashrc or similar shell configuration file:

```
export access_token=deadbeefdeadbeefdeadbeefdeadbeefdeadbeef
```

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please also consider contributing the dorks (githubtestdork.txt) that can reveal potentially sensitive information in github.
