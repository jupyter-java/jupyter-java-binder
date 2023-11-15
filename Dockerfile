# Start with Eclipse Temurin Java 17 as the base image
FROM eclipse-temurin:17-ubi9-minimal as working

RUN microdnf install -y python3-pip shadow-utils gcc python3-devel

ENV NB_USER javakernel
ENV NB_UID 1000
ENV HOME /home/$NB_USER

RUN groupadd -r -g 1000 ${NB_USER} \
  && useradd -r -u ${NB_UID} -g ${NB_USER} -m -d ${HOME} -s /bin/bash ${NB_USER}


COPY . $HOME
RUN chown -R $NB_UID $HOME

USER $NB_USER

# set path so jupyter install does not complain
ENV PATH $HOME/.jbang/bin:$HOME/.local/bin:$PATH

RUN pip3 install --no-cache-dir jupyter jupyterlab
RUN pip3 install jupyter

# Download the kernel release
RUN curl -Ls https://sh.jbang.dev | bash -s - app setup


RUN jbang version
RUN jbang trust add https://github.com/jupyter-java/
RUN jbang install-kernel@jupyter-java ijava
RUN jbang install-kernel@jupyter-java rapaio

# Launch the notebook server
WORKDIR $HOME

# trust notebooks
RUN jupyter trust *.ipynb

#RUN jupyter trust ./rapaio-bootstrap.ipynb
#RUN jupyter trust ./TitanicKaggleCompetition.ipynb


# binder does not allow internet access, as such we will use everything offline

#RUN curl -L https://github.com/padreati/rapaio/releases/download/5.1.0/rapaio-core-5.1.0.jar > rapaio-core-5.1.0.jar

CMD ["jupyter", "notebook", "--ip", "0.0.0.0"]
EXPOSE 8888