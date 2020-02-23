#!/usr/bin/python
import json
from bson import json_util
import bottle
from datetime import datetime
from bottle import route, run, request, abort
from pymongo import MongoClient

# Initialize default connection
connection = MongoClient('localhost', 27017)
db = connection['market']
collection = db['stocks']

# CHANGE DB PATH
@route('/stocks/api/v1.0/changeDatabase/<database>', method='POST')
def change_database(database):
  connect_to_database(database)
  if not database:
    abort(400, 'No data received')
  if result:
    return "{result:\"Successfully changed database\"}"
  else:
    return "{result:\"Failed to change database\"}"
  
# CHANGE COLLECTION
@route('/stocks/api/v1.0/changeCollection/<collection>', method='POST')
def change_collection(collection):
  connect_to_collection(collection)
  if not collection:
    abort(400, 'No data received')
  if result:
    return "{result:\"Successfully changed collection\"}"
  else:
    return "{result:\"Failed to change collection\"}"
 
# CHANGE COLLECTION PATH
@route('/stocks/api/v1.0/changeCollection/<collection>', method='POST')
def change_database(database):
  change_database(database)
  if not database:
    abort(400, 'No data received')
  if result:
    return "{result:\"Successfully changed database\"}"
  else:
    return "{result:\"Failed to change database\"}"
  
#CREATE PATH
@route('/stocks/api/v1.0/createStock/<ticker>', method='POST')
def post_create(ticker):
  data = request.body.readline()
  if not data:
    abort(400, 'No data received')
  entity = json.loads(data)
  result = str(create_document(entity))
  if result:
    return "{result:\"successful create\"}"
  else:
    return "{result:\"failed to create\"}"

#2 READ PATH
@route('/stocks/api/v1.0/getStock/<ticker>', method='GET')
def get_read(ticker):
  #ticker = request.query.ticker
  responseJson = str(read_document("Ticker", ticker))
  returnVal = "{}"
  if responseJson:
    returnVal = json.loads(json.dumps(responseJson, indent=4, default=json_util.default))
  return returnVal;

#2 UPDATE PATH
@route('/stocks/api/v1.0/updateStock/<ticker>', method='POST')
def post_update(ticker):
  data = request.body.readline()
  if not data:
    abort(400, 'No data received')
  entity = json.loads(data)
  updateObject = {"$set" : entity}
  responseJson = str(update_document("Ticker", ticker, updateObject))
  returnVal = "{}"
  if responseJson:
    returnVal = json.loads(json.dumps(responseJson, indent=4, default=json_util.default))
  pass

#2 DELETE PATH
@route('/stocks/api/v1.0/deleteStock/<ticker>', method='GET')
def post_delete(ticker):
  responseJson = str(delete_document("Ticker", ticker))
  if responseJson != None:
    return "{result:\"successful delete\"}"
  else:
    return "{result:\"failed to delete\"}"

# Returns true or false based on insert success
def create_document(document):
  result = None
  try:
    result=collection.insert_one(document)
    return result.acknowledged
  except PyMongoError as err:
    abort(400, str(ve))
    return false

# Returns a cursor object to an array of the results matching filter
def read_document(filterKey, filterValue):
  result = None
  filterDoc = { filterKey : filterValue }
  try:
    result = collection.find_one(filterDoc)
  except PyMongoError as err:
    abort(400, str(te))
  return result

# Uses a filtering key and value to apply the supplied json as updates
def update_document(filterKey, filterValue, updateJson):
  result = None
  filterDoc = { filterKey : filterValue }
  try:
    result = collection.update(filterDoc, updateJson)
  except PyMongoError as err:
    abort(400, str(err))
  return result

# Uses a filtering key and value to delete a single document from the db
def delete_document(filterKey, filterValue):
  result = None
  filterDoc = { filterKey : filterValue }
  try:
    result = collection.delete_one(filterDoc)
  except PyMongoError as err:
    abort(400, str(te))
  return result

# Run the server - remains running awaiting requests
if __name__ == '__main__':
  #app.run(debug=True)
  run(host='localhost', port=8080)
