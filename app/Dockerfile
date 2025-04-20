FROM public.ecr.aws/lambda/python:3.8

# Copy function code and dependencies
COPY app.py ${LAMBDA_TASK_ROOT}
COPY requirements.txt ${LAMBDA_TASK_ROOT}

# Install dependencies
RUN pip install -r ${LAMBDA_TASK_ROOT}/requirements.txt

# Ensure all files are accessible
RUN chmod -R o+rX .

# Set the CMD to your handler
CMD [ "app.lambda_handler" ]