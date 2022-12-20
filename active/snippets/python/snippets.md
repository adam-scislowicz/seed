# Python Snippets

## JSON Load File to Dictionary
```python
import json

with open(<JSON_FILE_PATH>, 'r') as json_file:
    json_data_as_dict = json.load(json_file)
    print(json_data_as_dict)
```
