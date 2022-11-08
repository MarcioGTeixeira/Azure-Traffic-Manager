# Azure Traffic Manager


##  Infraestrutura (iac) Terraform - Azure Traffic Manager - com pipeline de CI em azure DevOps.

- Projeto - implantar infraestrutura de WebApp, em 3 regiões: Brasil South , East US, Uk South, com redirecionamento geográfico com Traffic Manager. Cada usuário será redirecionado ao endpoint configurado para sua região.

### Configuração do arquivo azurepipelines.yaml
- A pipeline utiliza um self-hosted agent , podendo ser alterada para utilizar um Microsoft-hosted agents

Obs: Para utilização do BridgeCrew, é necessário ter uma conta criada e referenciar a API Key conforme task, e também pode ser utilizado como módulo, sendo referenciado no arquivo main.tf

module "bridgecrew-read" {  
  source           = "bridgecrewio/bridgecrew-azure-read-only/azure"  
  org_name         = "acme"  
  bridgecrew_token = "YOUR_TOKEN"  
}  


- A pipeline executa os seguintes **Steps**:<br>
instala a última versão do terraform  
inicializa o terraform  
valida as configurações  
instala o python  
instala o BridgeCrew e efetua análise de vulnerabilidade  
 





