//import liraries
import React, { Component } from "react";
import {
  View,
  Text,
  StyleSheet,
  TextInput,
  Picker,
  TouchableOpacity,
  Alert,
  AsyncStorage
} from "react-native";
import ApiClient from "../../Utils/ApiClient";
// create a component
class BookEdit extends Component {
  static navigationOptions = {
    title: "Edit",
    headerStyle: { backgroundColor: "#2c3e50" },
    headerTitleStyle: { color: "white" }
  };
  constructor(props) {
    super(props);
    const { state } = this.props.navigation;
    var book = state.params ? state.params.book : "<undefined>";
    this.state = {
      title: book.title,
      author: book.author.id,
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

  render() {
    const { state } = this.props.navigation;
    var book = state.params ? state.params.book : "<undefined>";
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
            this.setState({ author: itemValue })}
        >
          {authorItems}
        </Picker>

        <TouchableOpacity style={styles.buttonContainer} onPress={this.update}>
          <Text style={styles.buttonText}>UPDATE</Text>
        </TouchableOpacity>
      </View>
    );
  }

  update = async () => {
    const { state } = this.props.navigation;
    var book = state.params ? state.params.book : "<undefined>";
    var bookid = book.id;
    var author = this.state.author === "" ? book.author.id : this.state.author
    var resp = await ApiClient.updateBook(
      bookid,
      this.state.title,
      author
    )
      if (resp.ok === true) {
        //update successful
        
        await AsyncStorage.setItem('newtitle',resp.res.title);
        var newAuthorName = resp.res.author.firstName + " "+ resp.res.author.lastName;
        await AsyncStorage.setItem('newauthor',newAuthorName);
        this.props.navigation.state.params.onGoBack();
        this.props.navigation.goBack();

      } else {
        //error updating
        Alert.alert("Error", "Error");
      }

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
export default BookEdit;
