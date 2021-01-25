import flask
import json
from kbqa_test import *

app = flask.Flask(__name__)
app.config["MONGO_URI"] = "mongodb://localhost:27017/test"

@app.route('/')
def index():
    print("here")
    return flask.render_template('index1.html', has_result=False)

@app.route('/signup', methods=['POST'])
def signup():
    question = flask.request.form['infos']
    print(question)
    handler = KBQA()
    answer = handler.qa_main(question)
    return answer

@app.route('/login', methods=['POST'])
def login():
    user = flask.request.form['username']
    print(user)
    result = mongo.db.users.find({"name": user})
    if(result.count() == 0):
        print('用户不存在')
        return json.dumps({"success": 0})
    else:
        return json.dumps({"success": 1})

if __name__ == '__main__':
     app.run(debug=True, host='0.0.0.0', port=10086)
