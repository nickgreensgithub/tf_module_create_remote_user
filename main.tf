variable "connection" {
type = object({
    ip =string
    user=string
    private_key=string
})
} 

# variable "vm_ids" {
#     type=list(string)
# }

variable "user"{
    type = object({
        name = string
        is_sudo = bool
        public_ssh=string
    })
} 


resource "null_resource" "create_new_remote_user" {
    //remote exec required to delay running of local-exec provisioner below until machine is available
    provisioner "remote-exec" {
        connection {
            host = var.connection.ip
            user = var.connection.user
            private_key = file(var.connection.private_key)
        } 
        inline = ["echo 'connected!'"]
    }
    //making an ansible user and setting its ssh key
    #TODO pass variables to playbook for user to create
    provisioner "local-exec" {
        command = "ansible-playbook -i ${var.connection.ip}, ${path.module}/ansible_create_user/main.yml --private-key ${var.connection.private_key} --user ${var.connection.user}"
        //TODO can this be a relative path?
    }    
}