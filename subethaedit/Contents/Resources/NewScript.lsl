/*
    this
    is
    a
    block
    comment
*/

user_defined_function(string message)
{   // this is a line comment
    llSay(PUBLIC_CHANNEL, message);
}

string get_timestamp()
{
    return llGetTimestamp();
}

default
{
    state_entry()
    {
        user_defined_function("Hello, Avatar!");
    }

    touch_start(integer num_detected)
    {
        user_defined_function(get_timestamp());
    }
}
