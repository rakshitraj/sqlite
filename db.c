#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/**
 * @brief Read a line of input.
 * Store the read line in input_buffer->buffer and the size of the allocated buffer in input_buffer->buffer_length.
 * We store the return value in input_buffer->input_length
 * 
 * @param lineptr A pointer varibale to the variable we use to point to the buffer containting the read line. If it set to NULL it is mallocated by getline and should thus be freed by the user, even if thr command fails.
 * @param n A pointer to the variable we use to save the alocated buffer
 * @param stream The input stream to read from. We'll read from stdin
 * @return ssize_t The number of bytes rad, which may be less than the size of the buffer
 */
ssize_t getline(char **lineptr, size_t *n, FILE *stream);

typedef struct {
    char* buffer;
    size_t buffer_length;
    ssize_t input_length;
} InputBuffer;

InputBuffer* new_input_buffer() {
    InputBuffer* input_buffer = (InputBuffer*)malloc(sizeof(InputBuffer));
    input_buffer->buffer = NULL;
    input_buffer->buffer_length = 0;
    input_buffer->input_length = 0;

    return input_buffer;
}

void print_prompt(){
    printf("db > ");
}

void read_input(InputBuffer* input_buffer) {
    ssize_t bytes_read = getline(&(input_buffer->buffer), &(input_buffer->buffer_length), stdin);

    if (bytes_read <= 0) {
        printf("Error reading input\n");
        exit(EXIT_FAILURE);
    }

    // Ignore trailing newline
    input_buffer->input_length = bytes_read -1;
    input_buffer->buffer[bytes_read - 1] = 0;
}

void close_input_buffer(InputBuffer* input_buffer) {
    free(input_buffer->buffer);
    free(input_buffer);
}

int main(int argc, char* argv[]) {
    InputBuffer* input_buffer = new_input_buffer();
    while (true) {
        print_prompt();
        read_input(input_buffer);

        if (strcmp(input_buffer->buffer, ".exit") == 0) {
            close_input_buffer(input_buffer);
            exit(EXIT_SUCCESS);
        }
        else {
            printf("Unrecognized command '%s'. \n", input_buffer->buffer);
        }
    }
}
