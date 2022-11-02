FROM python:3.8
WORKDIR /tmp
COPY hello.txt .
RUN pip install --no-cache-dir --upgrade pip
CMD python3 -m http.server 80 --directory /tmp/ 
EXPOSE 80

