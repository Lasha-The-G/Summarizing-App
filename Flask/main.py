from flask import Flask, jsonify, request
from flask_cors import CORS
import json

from transcription import transcribe_audio
from summarization import summarize_long_text
from reformating import reformat_summarization


app = Flask(__name__)
CORS(app)

summaryLen = 0

@app.route('/slen', methods=['POST'])
def upload_summary_len():
    print("We're submitting summary lentgh")
    global summaryLen
    request_data = request.data
    request_data = json.loads(request_data.decode('utf-8'))
    summaryLen = request_data['sumLen']
    print(summaryLen)

    return jsonify({'weGood':"Yes we're good"})

@app.route('/tran', methods=['POST'])
def transcribeTheAudio():
    print("We are in transcribe")    
    if 'audioFile' not in request.files:
        return jsonify({"transcript": "No file part"}), 400

    file = request.files['audioFile']
    
    file.save('uploads\\' + file.filename)        
    print(file.filename)

    transcript = transcribe_audio("uploads\\" + file.filename)    

    return jsonify({"transcript": transcript}), 200    



@app.route('/summ', methods = ["POST"])
def summarize():
    print("We are in summarize")  
    request_data = request.data
    request_data = json.loads(request_data.decode("utf-8"))
    toSummarize = request_data['transcript']

    summary = summarize_long_text(toSummarize)

    return jsonify({"summary": summary})



@app.route('/refo', methods = ["POST"])
def reformat():
    global summaryLen
    print("We are in reformat")  
    request_data = request.data
    request_data = json.loads(request_data.decode("utf-8"))
    toRefomat = request_data['summary']

    output = reformat_summarization(toRefomat, summaryLen)

    return jsonify({'reformated': output})


if __name__ == "__main__":
    app.run(debug=True)
