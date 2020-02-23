import json
import pprint
from bson import json_util
from bson.son import SON
from pymongo import MongoClient

connection = MongoClient('localhost', 27017)
db = connection['market']
collection = db['stocks']

# Configure connection to the database
def connect_to_database(database, collect):
  db = connection[database]
  collection = db[collect]
  # Error checking to inform if the connection was successful
  if db != None and collection ! = None:
    return true
  else
    return false

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

# Returns the 50 day range given a low and high value
def find_50_day_range(low, high):
  pipeline = [
    { "$match": { "50-Day Simple Moving Average": {"$gt" : low, "$lt" : high} } }, 
    { "$group": { "_id": "null", "Total stocks within bounds": { "$sum": 1 } } }
  ]
  return list(collection.aggregate(pipeline))

# Returns tickers given an industry string
def find_tickers_by_industry(industry):
  return list(collection.find({"Industry":industry},{"Ticker":1,"_id":0}))

# Returns outstanding shares in a given sector
def find_outstanding_in_sector(sector):
  pipeline = [
    { "$match": {"Sector":sector} },
    { "$group": {"_id":{ "Industry": "$Industry"}, "totalShares":{ "$sum": "$Shares Outstanding" }}}
  ]
  return list(collection.aggregate(pipeline))


# Testing function to validate the creation functions
def test2a():
  print("\n2A Test Case: Insert Key-Value Pairs")
  print("Testing insertion of this document:")
  createTest = {"Ticker":"Testing", "Sector":"Project"}
  print(createTest)
  print("Result: " + str(create_document(createTest)))

# Testing function for updating
def test2b():
  print("\n2B Test Case: Updating Ticker Volume")
  print("Testing update of Ticker A with Volume of 550100")
  # Create the update object and submit to update function
  updateValues = {"Volume" : 550100}
  updateObject = {"$set" : updateValues}
  updateTest = update_document("Ticker", "A", updateObject)
  print("Update Result: " + str(updateTest))
  # Print out another read function to show it has changed
  print("The volume entry should now be 550100")
  print read_document("Ticker", "A")

# Testing function for deleting
def test2c():
  print("\n2C Test Case: Deleting a document by Ticker")
  # Delete the entry we created for these tests
  deleteTest = delete_document("Ticker", "Testing")
  print("Deletion result: " + str(deleteTest))
  readTest = read_document("Ticker", "Testing")
  if readTest != None:
    print readTest
    print("We found something, delete failed!")
  else:
    print("There are no matching objects, delete successful")

test2a()

test2b()

test2c()

print("Counting all stocks with a fifty day range between 0.01 and 0.011")
pprint.pprint(find_50_day_range(0.01,0.011))

print("Finding all tickers in the Medical Laboratories & Research Industry")
pprint.pprint(find_tickers_by_industry("Medical Laboratories & Research"))

print("Counting total outstanding shares, grouped by industry")
pprint.pprint(find_outstanding_in_sector("Healthcare"))
