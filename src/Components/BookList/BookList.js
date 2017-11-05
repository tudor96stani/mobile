//import liraries
import React, { Component } from "react";
import {
  View,
  Text,
  StyleSheet,
  Button,
  FlatList,
  AsyncStorage,
  Alert
} from "react-native";
import * as URLS from "../Utils/ApiClient";
// create a component
class BookList extends Component {
  constructor(props) {
    super(props);

    this.state = {
      userid: "",
      token: "",
      dataSource: [
        {
          title: "",
          author: {
            firstName: "",
            lastName: ""
          }
        }
      ]
    };
  }

  componentDidMount() {
    /*
      const id =  AsyncStorage.getItem('userid').then((r)=>{}).done();
      const token =  AsyncStorage.getItem('token').then((r)=>{}).done();
      AsyncStorage.multiGet
      const headers = 
      
      fetch(url,{
          method : 'GET',
          headers:headers
      })
      .then((response) => {
          if (response.status >= 200 && response.status < 300)
            return response;
            else{
                let error = new Error(response.statusText);
          error.message = "Error";
          let code = response.status;
          console.log("Status :" + code);
          error.response = response;
          throw error;
            }
      })*/

    AsyncStorage.getItem("userid").then(userid => {
      this.setState({ userid: userid });
      AsyncStorage.getItem("token").then(token => {
        const headers = {
          Authorization: "Bearer " + token
        };
        const url = URLS.GET_BOOKS_URL + this.state.userid;
        this.setState({ token: token });
        fetch(url, {
          method: "GET",
          headers: {
            Authorization: "Bearer " + this.state.token
          }
        })
          .then(response => {
            if (response.status >= 200 && response.status < 300)
              return response;
            else {
              let error = new Error(response.statusText);
              //error.message = "Error";
              let code = response.status;
              console.log("Status :" + code);
              error.response = response;
              throw error;
            }
          })
          .then(response => response.json())
          .then(res => {
            this.setState({ dataSource: res });
          })
          .catch(e => {
            Alert.alert(e.message);
          })
          .done();
      });
    });
  }

  render() {
    return (
      <View style={styles.container}>
        <FlatList
          data={this.state.dataSource}
          renderItem={({ item }) => (
            <View style={styles.cell}>
              <Text style={styles.text}>{item.title}</Text>
              <Text style={styles.text}>
                {item.author.firstName} {item.author.lastName}
              </Text>
            </View>
          )}
          keyExtractor={(item, index) => index}
        />
      </View>
    );
  }
}

// define your styles
const styles = StyleSheet.create({
  container: {
    flex: 1,
    marginTop: 20
  },
  rowContainer: {
    flex: 1,
    padding: 12,
    flexDirection: "row",
    alignItems: "center"
  },
  text: {
    marginLeft: 12,
    fontSize: 20
  },
  cell: {
    flex: 1,
    margin: 5,
    backgroundColor: "rgba(255,255,255,0.5)",
    height:50
  }
});

//make this component available to the app
export default BookList;
