## Adjust the java version and kernels you want to have installed
: "${JAVA_VERSION:=25}"
jbang install-kernel@jupyter-java --java $JAVA_VERSION jbang
jbang install-kernel@jupyter-java --java $JAVA_VERSION jjava
jbang install-kernel@jupyter-java --java $JAVA_VERSION rapaio
jbang install-kernel@jupyter-java --java $JAVA_VERSION kotlin
jbang install-kernel@jupyter-java --java $JAVA_VERSION ijava
