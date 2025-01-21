import sys
 
 
class User:
 
    def __init__(self, **dict1):
        self.user = dict1
        self.id = dict1["Mobile No"]
        self.email = dict1["Email"]
        self.__passw = dict1["Password"]
        self.lg_status = False
 
    def login(self):
        id = input("Enter mobile no: ")
        if id.isdigit():
            id = int(id)
        else:
            id = str(id)
        passw = input("Enter password:")
        if id == self.id or id == self.email:
            if passw == self.__passw:
                print("successfully loggedin")
                self.lg_status = True
            else:
                print("wrong password")
        else:
            print("wrong username")
 
    def bookTicket(self):
        self.from1 = input("Enter source destination: ")
        self.to = input("Enter destination location:")
        try:
            if self.lg_status:
                print(
                    f"ticket confirmed from {self.from1.title()} to {self.to.title()}  "
                )
            else:
                raise Exception("not loggedin")
        except:
            print(sys.exc_info())
 
 