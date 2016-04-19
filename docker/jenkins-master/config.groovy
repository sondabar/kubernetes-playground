import hudson.security.HudsonPrivateSecurityRealm
import jenkins.model.Jenkins
import org.csanchez.jenkins.plugins.kubernetes.KubernetesCloud
import org.csanchez.jenkins.plugins.kubernetes.PodTemplate

// disable executors on master
Jenkins.instance.setNumExecutors(0)

// enable security
Jenkins.instance.setSecurityRealm(new HudsonPrivateSecurityRealm(false));
Jenkins.instance.setAuthorizationStrategy(new HudsonPrivateSecurityRealm(false))

// Configure kubernetes plugin
PodTemplate podTemplate = new PodTemplate("sondabar/jenkins-slave-jnlp", Collections.emptyList())
podTemplate.setName("jenkins-slave-jnlp")
podTemplate.setInstanceCap(10)
podTemplate.setNodeSelector("")
KubernetesCloud kubernetesCloud = new KubernetesCloud("ci-cloud", Collections.singletonList(podTemplate), "https://kubernetes.default", "ci", "http://jenkins-master.ci", "10", 10, 5, 5);
Jenkins.instance.clouds.add(kubernetesCloud)