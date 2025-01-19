import sys

class User():
    
    def __init__(self,**dict1):
        self.user = dict1
        self.id = dict1['email']
        self.passw = dict1['Password']
        self.lg_status = False

    def login(self,id,passw):
        if id == self.id:
            if passw == self.passw:
                print("successfully loggedin")
                self.lg_status = True
            else:
                print("wrong password")
        else:
            print("wrong username")
    
    def bookTicket(self,to,froml):
        try:
            if self.lg_status:
                print(f"ticket confirmed from {str(froml).title} to {str(to).title}  ")
            else:
                raise Exception("not loggedin")
        except:
            print(sys.exc_info())
    