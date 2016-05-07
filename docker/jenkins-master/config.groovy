import hudson.security.GlobalMatrixAuthorizationStrategy
import hudson.security.HudsonPrivateSecurityRealm
import jenkins.model.Jenkins
import org.csanchez.jenkins.plugins.kubernetes.KubernetesCloud
import org.csanchez.jenkins.plugins.kubernetes.PodTemplate

def env = System.getenv()
def password = env['JENKINS_PASSWORD']

def instance = Jenkins.getInstance()

// disable executors on master
instance.setNumExecutors(0)

// enable security
def hudsonRealm = new HudsonPrivateSecurityRealm(false)
hudsonRealm.createAccount("admin",password)
instance.setSecurityRealm(hudsonRealm)
def strategy = new GlobalMatrixAuthorizationStrategy()
strategy.add(Jenkins.ADMINISTER, "admin")
instance.setAuthorizationStrategy(strategy)
instance.save()

// Configure kubernetes plugin
PodTemplate podTemplate = new PodTemplate("sondabar/jenkins-slave-jnlp", Collections.emptyList())
podTemplate.setName("jenkins-slave-jnlp")
podTemplate.setInstanceCap(10)
podTemplate.setNodeSelector("")
KubernetesCloud kubernetesCloud = new KubernetesCloud("ci-cloud", Collections.singletonList(podTemplate), "https://kubernetes.default", "ci", "http://jenkins-master.ci", "10", 10, 5, 5);
Jenkins.instance.clouds.add(kubernetesCloud)

Jenkins.instance.save()