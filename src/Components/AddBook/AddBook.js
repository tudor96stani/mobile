//import liraries
import React, { Component } from "react";
import {
  View,
  Text,
  StyleSheet,
  AsyncStorage,
  Picker,
  Alert,
  TextInput,
  TouchableOpacity
} from "react-native";
import ApiClient from "../../Utils/ApiClient";

// create a component
class AddBook extends Component {
  static navigationOptions = {
    title: "Edit",
    headerStyle: { backgroundColor: "#2c3e50" },
    headerTitleStyle: { color: "white" }
  };
  constructor(props) {
    super(props);
    this.state = {
      title: "",
      author: "",
      authors: [{ id: "1", firstName: "Loading authors...", lastName: "" }]
    };
  }

  componentDidMount() {
    this.fetchAuthors();
  }

  fetchAuthors = () => {
    ApiClient.fetchAuthors().then(authors => {
      this.setState({ authors: authors });
    });
  };

  save = async () => {
    
    var title = this.state.title;
    var authorid = "";
    console.log(this.state.author);
    if (this.state.author !== "") {
      authorid = this.state.author;
    } else {
      authorid = this.state.authors[0].id;
    }
    var addResult = await ApiClient.addBook(title, authorid);
    console.log(addResult);
    if (addResult.ok === true) {
      Alert.alert(addResult.res.title + " was added successfully!");
    } else {
      Alert.alert(addResult.message);
    }
    this.props.navigation.state.params.onGoBack();
    this.props.navigation.goBack();
  

  };

 

  render() {
    const { state } = this.props.navigation;
    const { navigate } = this.props.navigation;
    let authorItems = this.state.authors.map(data => {
      return (
        <Picker.Item
          key={data.id}
          value={data.id}
          label={data.firstName + " " + data.lastName}
        />
      );
    });
    return (
      
      <View style={styles.container}>
        <TextInput
          style={styles.input}
          autoCapitalize="none"
          onChangeText={title => this.setState({ title })}
          autoCorrect={false}
          keyboardType="default"
          returnKeyType="next"
          value={this.state.title}
          placeholder="Title"
          placeholderTextColor="rgba(225,225,225,0.7)"
        />

        <Picker
          selectedValue={this.state.author}
          onValueChange={(itemValue, itemIndex) =>
            this.setState({ author: itemValue })
          }
        >
          {authorItems}
        </Picker>

        <TouchableOpacity style={styles.buttonContainer} onPress={this.save}>
          <Text style={styles.buttonText}>Add</Text>
        </TouchableOpacity>
        <TouchableOpacity style={styles.buttonContainer} 
          onPress={
              () => 
              navigate("AddAuthor",{onGoBack: () => this.fetchAuthors()})
              }>
          <Text style={styles.buttonText}>Add author</Text>
        </TouchableOpacity>
      </View>
    );
  }
}

// define your styles
const styles = StyleSheet.create({
  container: {
    flex: 1,
    paddingTop: 50,
    padding: 20,
    backgroundColor: "#2c3e50"
  },
  input: {
    height: 40,
    backgroundColor: "rgba(225,225,225,0.2)",
    marginBottom: 5,
    padding: 10,
    color: "#fff"
  },
  buttonContainer: {
    backgroundColor: "#2980b6",
    paddingVertical: 15,
    marginTop: 30
  },
  buttonText: {
    color: "#fff",
    textAlign: "center",
    fontWeight: "700"
  },
  labelText: {
    color: "white",
    textAlign: "center",
    fontWeight: "600",
    paddingBottom: 50,
    fontSize: 40
  }
});

//make this component available to the app
export default AddBook;
