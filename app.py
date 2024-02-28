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
    city = res[0]
    file = res[1]
    msg = res[2]
    img_url = res[3]
    temp = res[4]
    humidity = res[5]
    wind = res[6]
    precip = res[7]
    return render_template('result.html', msg=msg, img_url = img_url, temp=temp, city=city, file=file, humidity=humidity, wind=wind, precip=precip)

def execute_shell_script(input_text):
    current_dir = os.path.dirname(os.path.abspath(__file__))
    script_path = os.path.join(current_dir, 'weatheroutput.sh')

    try:
        result = subprocess.check_output('{} {}'.format(script_path, input_text), shell=True)
        return result.decode('utf-8')

    except subprocess.CalledProcessError as e:
        return "Error: {}".format(e.output.decode('utf-8'))

if __name__ == '__main__':
    app.run(debug=True)
