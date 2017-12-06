class Operation {
    type: string;
    params: [];
    constructor(type,params){
        this.type=type;
        this.params=params;
    }

    process = () => {
        return this.params;
    }
}