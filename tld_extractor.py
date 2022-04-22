
import tldextract
import sys 

full_url = sys.argv[1]

result = tldextract.extract(full_url)

print(result.registered_domain)
