#--- ID (Internal Customer ID) ---
idToEmail() {
    local envOption
    if [ "$2" = "p" ]; then
        envOption="-e production"
    elif [ "$2" = "s" ]; then
        envOption="-e staging"
    else
        echo "Invalid environment. Please use 's' for staging or 'p' for production."
        return 1
    fi

    dockyard-rpc -f getEmailByCustomerId -s customer-identity $envOption -d "\"$1\""
}

emailToId() {
    local envOption
    if [ "$2" = "p" ]; then
        envOption="-e production"
    elif [ "$2" = "s" ]; then
        envOption="-e staging"
    else
        echo "Invalid environment. Please use 's' for staging or 'p' for production."
        return 1
    fi

    dockyard-rpc -f getCustomerIdByEmail -s customer-identity $envOption -d "\"$1\""
}

idToEid() {
    local envOption
    if [ "$2" = "p" ]; then
        envOption="-e production"
    elif [ "$2" = "s" ]; then
        envOption="-e staging"
    else
        echo "Invalid environment. Please use 's' for staging or 'p' for production."
        return 1
    fi

    dockyard-rpc -f getCustomerExtIdByCustomerId -s customer-identity $envOption -d "\"$1\""
}

#--- CEXID (External Customer ID) ---
eidToEmail() {
    local envOption
    if [ "$2" = "p" ]; then
        envOption="-e production"
    elif [ "$2" = "s" ]; then
        envOption="-e staging"
    else
        echo "Invalid environment. Please use 's' for staging or 'p' for production."
        return 1
    fi

    dockyard-rpc -f getEmailByCustomerExtId -s customer-identity $envOption -d "\"$1\""
}

emailToEid() {
    local envOption
    if [ "$2" = "p" ]; then
        envOption="-e production"
    elif [ "$2" = "s" ]; then
        envOption="-e staging"
    else
        echo "Invalid environment. Please use 's' for staging or 'p' for production."
        return 1
    fi

    dockyard-rpc -f getEmailByCustomerExtId -s customer-identity $envOption -d "\"$1\""
}

eidToId() {
    local envOption
    if [ "$2" = "p" ]; then
        envOption="-e production"
    elif [ "$2" = "s" ]; then
        envOption="-e staging"
    else
        echo "Invalid environment. Please use 's' for staging or 'p' for production."
        return 1
    fi

    dockyard-rpc -f getCustomerIdByCustomerExtId -s customer-identity $envOption -d "\"$1\""
}

# Lazy magic
idInfo() {
    local identifier="$1"
    local env="$2"
    local id eid email response

    # Function to extract the response
    extractResponse() {
        echo "$1" | sed -n 's/^.*response: "\([^"]*\)".*$/\1/p'
    }

    # Check for presence of '@' to identify emails
    if [[ "$identifier" == *'@'* ]]; then
        echo "Identifier is an email."
        response=$(emailToId "$identifier" "$env")
        id=$(extractResponse "$response")
        response=$(emailToEid "$identifier" "$env")
        eid=$(extractResponse "$response")
        email="$identifier"
    # Check for presence of '-' to identify eids
    elif [[ "$identifier" == *'-'* ]]; then
        echo "Identifier is an id."
        response=$(idToEmail "$identifier" "$env")
        email=$(extractResponse "$response")
        response=$(idToEid "$identifier" "$env")
        eid=$(extractResponse "$response")
        id="$identifier"
    # If neither, assume it's an id
    else
      echo "Identifier is an eid."
      response=$(eidToEmail "$identifier" "$env")
      email=$(extractResponse "$response")
      response=$(eidToId "$identifier" "$env")
      id=$(extractResponse "$response")
      eid="$identifier"
    fi

    # Print the results
    echo "email: $email"
    echo "internal id: $id"
    echo "external id: $eid"
}
