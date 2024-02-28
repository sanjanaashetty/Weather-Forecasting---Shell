from flask import Flask, render_template, request
import subprocess
import os

app = Flask(__name__)

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/submit', methods=['POST'])
def submit():
    location = request.form.get('location')
    metrics = request.form.get('metrics')
    input_text = location + ' ' + metrics
    result = execute_shell_script(input_text)
    res = result.split("{")
    msg = res[0]
    img_url = res[1]
    temperature = res[2]
    return render_template('result.html', msg=msg, img_url = img_url, temperature = temperature)

def execute_shell_script(input_text):
    current_dir = os.path.dirname(os.path.abspath(__file__))
    script_path = os.path.join(current_dir, 'weatheroutput.sh')

    try:
        result = subprocess.check_output(f'{script_path} {input_text}', shell=True)
        return result.decode('utf-8')

    except subprocess.CalledProcessError as e:
        return f"Error: {e.output.decode('utf-8')}"

if __name__ == '__main__':
    app.run(debug=True)
