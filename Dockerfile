FROM ghcr.io/senergy-platform/converter:prod AS builder

FROM python:3-slim-buster

RUN apt-get update && apt-get install -y git

ADD . /opt/app
WORKDIR /opt/app

COPY --from=builder /root/converter.so converter_lib.so
COPY --from=builder /root/converter_arm.so converter_lib_arm.so

RUN if [["$(arch)" == "arm"]]; then cp -f converter_lib_arm.so converter_lib.so; fi

RUN chmod 777 /opt/app/converter_lib.so

ENV CONVERTER_LIB_LOCATION=/opt/app/converter_lib.so

RUN pip install --no-cache-dir -r requirements.txt
CMD [ "python", "-u", "./main.py" ]