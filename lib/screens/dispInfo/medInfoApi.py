from flask import Flask, jsonify, request
from groq import Groq
from flask_cors import CORS  # Add CORS support for cross-origin requests

app = Flask(__name__)
CORS(app)  # Enable CORS for all routes

client = Groq(api_key="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")

@app.route('/get_med_info', methods=['POST'])
def get_med_info():
    try:
        data = request.json
        med_name = data.get("medicine_name", "")
        print(med_name)
        
        if not med_name:
            return jsonify({"error": "Medicine name is required"}), 400
        
        prompt = (
            f"I am using you to fetch details of a medicine. Please give me response without lines such as 'glad to assist you' or ' happy to help you' etc or any introductory statements. just give me response in a well structured format."
            "Explain this medicine " + med_name + ". Why it's used, how to use it, benefits of it, "
            "side effects, how it works. Tell me whether it's safe to use with - "
            "1)Alcohol 2)While Driving 3)During Pregnancy. And also give its alternatives."
        )
        #print(prompt)
        
        chat_completion = client.chat.completions.create(
            messages=[{"role": "user", "content": prompt}],
            model="llama3-8b-8192",
        )
        
        response_text = str(chat_completion.choices[0].message.content)
        return jsonify({"medicine_info": response_text})
    
    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True, host="0.0.0.0", port=6210)