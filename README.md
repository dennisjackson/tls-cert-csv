# A quick and hacky TLS Certificate Extractor 

## Requirements

* [jq](https://stedolan.github.io/jq/)
* [tls-scan](https://github.com/prbinu/tls-scan)
* Bash - E.g. On Ubuntu or MacOS

## Usage

1. Open `generate.sh` in a text editor
2. Set `TLSSCAN` to the path to the `tls-scan` binary
3. Set `DOMAINS` to the path to the list of domains of interest, one ASCII domain per line with LF line endings. 
4. Type `./generate.sh` in your terminal. 
5. Results will appear as `.csv`'s in your `out` folder. 

## Notes

* Scanning each domain can take several seconds, so be prepared to wait. 
* You can edit `FIELDS` to extract more or less information from `raw_data.json`. 
* `jq` supports a versatile query language for easy filtering. 
