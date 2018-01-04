//import liraries
import React, { Component } from "react";
import {
  View,
  Text,
  StyleSheet,
  Button,
  FlatList,
  AsyncStorage,
  Alert,
  Icon,
  ListItem,
  TouchableOpacity
} from "react-native";
import * as URLS from "../../Utils/ApiClient";
import ApiClient from "../../Utils/ApiClient";

import Swipeout from "react-native-swipeout";
// create a component
class ViewerBookList extends Component {
  static navigationOptions = ({ navigation }) => {
    const { params = {} } = navigation.state;
    return {
      title: "All books",
      headerStyle: { backgroundColor: "#2c3e50" },
      headerTitleStyle: { color: "white" }
    };
  };

  constructor(props) {
    super(props);

    this.state = {
      refreshing: false,
      userid: "",
      token: "",
      dataSource: [
        {
          id: "",
          title: "",
          author: {
            firstName: "",
            lastName: ""
          }
        }
      ],
      activeRowId: null
    };
  }

  componentDidMount(){
      this.reloadData();
  }

  reloadData = () => {
    ApiClient.fetchAllBooks().then(books => {
      if (books != null) {
        this.setState({ dataSource: books });
      }
    });
  }

  refresh = () => {
    this.state.refreshing = true;
    this.componentDidMount();
    this.state.refreshing = false;
  };

  render() {
    return (
      <View style={styles.container}>
        <FlatList
          data={this.state.dataSource}
          renderItem={({ item }) => (
            <TouchableOpacity
              style={styles.cell}
              onPress={() =>{}}
            >
              <Text style={styles.text}>{item.title}</Text>
              <Text style={styles.text}>
                {item.author.firstName} {item.author.lastName}
              </Text>
            </TouchableOpacity>
          )}
          refreshing={this.state.refreshing}
          onRefresh={this.refresh}
          keyExtractor={(item, index) => item.id}
        />
      </View>
    );
  }
}

// define your styles
const styles = StyleSheet.create({
  container: {
    flex: 1,
    //marginTop: 10,
    backgroundColor: "#2c3e50"
    //paddingTop: 10
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
    backgroundColor: "#95a5a6",
    height: 50
  }
});

//make this component available to the app
export default ViewerBookList;
