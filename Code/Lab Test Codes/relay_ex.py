from __future__ import print_function
import qwiic_relay
import time
import sys

myRelays = qwiic_relay.QwiicRelay()

def runExample():

    print("\nSparkFun Qwiic Relay Example 1\n")

    if myRelays.begin() == False:
        print("The Qwiic Relay isn't connected to the system. Please check your connection", \
            file=sys.stderr)
        return
    
    #Turn on relays one and three
    myRelays.set_relay_on(1)
    # myRelays.set_relay_on(3)
    time.sleep(300)
    
    #Print the status of all relays
    for relayNum in range(1):
        current_status = None
        if myRelays.get_relay_state(relayNum) is True:
            current_status = "On"
        else:
            current_status = "Off"
        print("Status 1: " + current_status + "\n")
    
    #Turn off 1 and 3, turn on 2 and 4
    # myRelays.set_relay_off(1)
    # myRelays.set_relay_on(2)
    # myRelays.set_relay_off(3)
    # myRelays.set_relay_on(4)
    time.sleep(1)
    

    # #Turn all relays on, then turn them all off
    # myRelays.set_all_relays_on()
    # time.sleep(1)
    
    myRelays.set_all_relays_off()
    


if __name__ == '__main__':
    try:
        runExample()
    except (KeyboardInterrupt, SystemExit) as exErr:
        print("\nEnding Example 1")
        sys.exit(0)