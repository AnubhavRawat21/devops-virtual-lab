# VLE-5: End-to-End DevOps CI/CD Pipeline
**Student:** Anubhav Rawat (Reg No: RA2311050010057)  
**Course:** DevOps Engineering - Virtual Lab Experiment 5  

---

## 📋 Overview
Design and implementation of a complete, production-ready DevOps CI/CD pipeline featuring:
1. **Infrastructure as Code (IaC):** Cloud VM & VPC provisioning using **Terraform**.
2. **Configuration Management:** Server configuration & dependency orchestration using **Ansible**.
3. **Containerization:** Web application containerization using **Docker**.
4. **Container Orchestration:** Scalable application deployment on **Kubernetes (K8s)**.
5. **CI/CD Automation:** Automated Build, Container Test & Deployment workflow using **GitHub Actions**.

---

## 📁 Repository Structure
```text
devops-virtual-lab/
│── app/
│   ├── index.html            # Web Application Source
│   └── Dockerfile            # Container definition (Nginx based)
│
│── terraform/
│   └── main.tf               # Cloud infrastructure provisioning
│
│── ansible/
│   ├── inventory.ini         # Target server inventory
│   └── setup.yml             # Automated server setup playbook
│
│── k8s/
│   ├── deployment.yml        # Kubernetes multi-replica deployment
│   └── service.yml           # Kubernetes Service routing
│
└── .github/workflows/
    └── cicd.yml              # GitHub Actions Automated CI/CD Pipeline
```
