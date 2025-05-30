/// Constantes de texto para mensagens de erro
class ErrorMessages {
  static const String emptyField = "Este campo não pode estar vazio.";
  static const String listExists = "Essa Lista já existe!";
  static const String createListFirst = "Crie uma lista primeiro!";
  static const String loadListsError = "Erro ao carregar listas: ";
  static const String loadTasksError = "Erro ao carregar tarefas: ";
  static const String saveListsError = "Erro ao salvar listas: ";
  static const String saveTasksError = "Erro ao salvar tarefas: ";
  static const String deleteListError = "Erro ao deletar lista: ";
}

/// Constantes de texto para títulos
class Titles {
  static const String newList = "Nova Lista";
  static const String editList = "Renomear Lista";
  static const String newTask = "Nova Tarefa";
  static const String editTask = "Editar Tarefa";
  static const String delete = "Apagar";
  static const String appName = "Easy Tasks";
}

/// Constantes de texto para botões e ações
class ActionLabels {
  static const String create = "Criar";
  static const String save = "Salvar";
  static const String add = "Adicionar";
  static const String delete = "Apagar";
  static const String cancel = "Cancelar";
}

/// Constantes de texto para diálogos
class DialogTexts {
  static const String enterListName = "Insira o nome da Lista.";
  static const String confirmDelete = "Deseja realmente apagar este item?";
  static const String confirmDeleteList = "Deseja apagar a lista";
  static const String confirmDeleteTasks = "Deseja apagar as tarefas selecionadas?";
}

/// Constantes de texto para tooltips
class Tooltips {
  static const String selectAll = "Selecionar/Deselecionar todas";
  static const String deleteSelected = "Apagar selecionadas";
}
